//
//  NetworkLog+Overview.swift
//  NetworkMonitor
//
//  Created by Toshinori Watanabe on 12/29/17.
//  Copyright © 2017 Toshinori Watanabe. All rights reserved.
//

import UIKit

extension NetworkLog {

    var overview: NetworkLogOverview {
        return NetworkLogOverview(log: self)
    }

}

struct NetworkLogOverview {

    let log: NetworkLog

    var url: String {
        return log.request.url?.absoluteString ?? "-"
    }

    var status: String {
        if log.isLoading {
            return "Loading"
        }

        if log.error != nil {
            return "Failed"
        }

        return "Completed"
    }

    var responseCode: String {
        guard let httpResponse = log.response as? HTTPURLResponse else {
            return "-"
        }
        let code = httpResponse.statusCode
        let text = HTTPURLResponse.localizedString(forStatusCode: code)

        return "\(code) \(text)"
    }

    var method: String {
        return log.request.httpMethod?.uppercased(with: nil) ?? "-"
    }

    var contentType: String {
        guard let httpResponse = log.response as? HTTPURLResponse else {
            return "-"
        }

        if let value = httpResponse.allHeaderFields["Content-Type"] as? String {
            return value
        }

        return "-"
    }

    var duration: String {
        guard let responseEndDate = log.responseEndDate else {
            return "-"
        }
        return prrettyTimeDifference(start: log.requestStartDete, end: responseEndDate)
    }

    var requestDuration: String {
        guard let requestEndDate = log.requestEndDate else {
            return "-"
        }

        return prrettyTimeDifference(start: log.requestStartDete, end: requestEndDate)
    }

    var responseDuration: String {
        guard let responseStarDate = log.responseStartDete,
            let responseEndDate = log.responseEndDate else {
                return "-"
        }

        return prrettyTimeDifference(start: responseStarDate, end: responseEndDate)
    }

    var requestSize: String {
        let headerSize = log.request.allHTTPHeaderFields?.description.data(using: .utf8)?.count ?? 0
        let bodySize = log.request.httpBody?.count ?? 0
        return prettyBytes(bytes: headerSize + bodySize)
    }

    var responseSize: String {
        let headerSize = (log.response as? HTTPURLResponse)?.allHeaderFields.description.data(using: .utf8)?.count ?? 0
        let bodySize = log.data?.count ?? 0
        return prettyBytes(bytes: headerSize + bodySize)
    }

    var totalSize: String {
        let requestHeaderSize = log.request.allHTTPHeaderFields?.description.data(using: .utf8)?.count ?? 0
        let requestBodySize = log.request.httpBody?.count ?? 0
        let responseHeaderSize = (log.response as? HTTPURLResponse)?.allHeaderFields.description.data(using: .utf8)?.count ?? 0
        let responseBodySize = log.data?.count ?? 0
        return prettyBytes(bytes: requestHeaderSize + requestBodySize + responseHeaderSize + responseBodySize)
    }

    // MARK: - Convert format

    private func prrettyTimeDifference(start: Date, end: Date) -> String {
        let difference = end.timeIntervalSince(start)

        if difference >= 60.0 {
            let minutes = Int(difference / 60)
            let seconds = Int(difference - Double(minutes * 60))

            return String(format: "%d m %d s", minutes, seconds)
        }

        if difference >= 1.0 {
            return String(format: "%0.2f s", difference)
        }

        return String(format: "%0.2f ms", difference * 1000)
    }

    private func prettyBytes(bytes: Int) -> String {
        let scale: Double = 1024
        let abbrevs = ["GB", "MB", "KB", "bytes"]

        let bytes = Double(bytes)
        var maximum = pow(Double(scale), Double(abbrevs.count - 1))

        for i in 0 ..< abbrevs.count - 1 {
            if bytes > maximum {
                return String(format: "%0.2f %@", (bytes / maximum), abbrevs[i])
            }

            maximum /= scale
        }

        return String(format: "%d bytes", Int(bytes))
    }

}
