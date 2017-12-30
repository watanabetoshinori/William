//
//  NetworkMonitorController+Rows.swift
//  NetworkMonitor
//
//  Created by Watanabe Toshinori on 12/31/17.
//

import UIKit

extension NetworkMonitorController {

    // MARK: - Generating Details for Selected Log

    func generateOverviewSections() -> [Section] {
        guard let log = Session.current.selectedLog else {
            return []
        }

        let requestContents: [Row] = {
            var contents = [Row]()
            if let row = generateRequestHeaderRow() {
                contents.append(row)
            }
            if let row = generateRequestQueryRow() {
                contents.append(row)
            }
            if let row = generateRequestCookieRow() {
                contents.append(row)
            }
            if let row = generateRequestTextRow() {
                contents.append(row)
            }
            if let row = generateRequestBodyRow() {
                contents.append(row)
            }

            if contents.isEmpty {
                contents.append(Row("None"))
            }

            return contents
        }()

        let responseContents: [Row] = {
            var contents = [Row]()
            if let row = generateResponseHeaderRow() {
                contents.append(row)
            }
            if let row = generateResponseTextRow() {
                contents.append(row)
            }
            if let row = generateResponseBoxyRow() {
                contents.append(row)
            }

            if contents.isEmpty {
                contents.append(Row("None"))
            }

            return contents
        }()

        return [
            Section("Overview", generateOverviewRows(log)),
            Section("Request", requestContents),
            Section("Response", responseContents),
            Section("Timing", generateTimingRows(log)),
            Section("Size", generateSizeRows(log))
        ]
    }

    private func generateOverviewRows(_ log: NetworkLog) -> [Row] {
        let overview = log.overview
        return [
            Row("URL", overview.url),
            Row("Status", overview.status),
            Row("Response Code", overview.responseCode),
            Row("Method", overview.method),
            Row("Content-Type", overview.contentType)
        ]
    }

    private func generateTimingRows(_ log: NetworkLog) -> [Row] {
        let overview = log.overview
        return [
            Row("Request Start Time", overview.log.requestStartDete.string("yy/MM/dd H:mm:ss")),
            Row("Request End Time", overview.log.requestEndDate?.string("yy/MM/dd H:mm:ss") ?? "-"),
            Row("Response Start Time", overview.log.responseStartDete?.string("yy/MM/dd H:mm:ss") ?? "-"),
            Row("Response End Time", overview.log.responseEndDate?.string("yy/MM/dd H:mm:ss") ?? "-"),
            Row("Request", overview.requestDuration),
            Row("Response", overview.responseDuration),
            Row("Duration", overview.duration)
        ]
    }

    private func generateSizeRows(_ log: NetworkLog) -> [Row] {
        let overview = log.overview
        return [
            Row("Request", overview.requestSize),
            Row("Response", overview.responseSize),
            Row("Total", overview.totalSize)
        ]
    }

    private func generateRequestHeaderRow() -> Row? {
        guard let log = Session.current.selectedLog,
            let headers = log.request.allHTTPHeaderFields else {
                return nil
        }

        let rows = headers.map { (header) -> Row in
            return Row(header.key, header.value)
        }

        return Row("Headers", sections: [Section("Headers", rows)])
    }

    private func generateRequestQueryRow() -> Row? {
        guard let log = Session.current.selectedLog,
            let url = log.request.url,
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
            let queryItems = components.queryItems else {
                return nil
        }

        let rows = queryItems.map({ (queryItem) -> Row in
            return Row(queryItem.name, queryItem.value)
        })

        return Row("Query Strings", sections: [Section("Query Strings", rows)])
    }

    private func generateRequestCookieRow() -> Row? {
        guard let log = Session.current.selectedLog,
            let url = log.request.url,
            let cookies = HTTPCookieStorage.shared.cookies(for: url),
            cookies.isEmpty == false else {
                return nil
        }

        let rows = cookies.map { (cookie) -> Row in
            return Row(cookie.name, cookie.value)
        }

        return Row("Cookies", sections: [Section("Cookies", rows)])
    }

    private func generateRequestTextRow() -> Row? {
        guard let log = Session.current.selectedLog,
            let data = log.request.httpBodyStream?.read() else {
                return nil
        }

        if data.isEmpty {
            return nil
        }

        return Row("Text", identifier: "RequestTextViewController")
    }

    private func generateRequestBodyRow() -> Row? {
        guard let log = Session.current.selectedLog,
            let data = log.request.httpBody else {
                return nil
        }

        if data.isEmpty {
            return nil
        }

        guard let contentType = ContentDataViewController.supportedContentTypeName(for: log.content.requestContentType) else {
            return nil
        }

        return Row(contentType.rawValue, identifier: "RequestBodyViewController")
    }

    private func generateResponseHeaderRow() -> Row? {
        guard let log = Session.current.selectedLog,
            let httpResponse = log.response as? HTTPURLResponse else {
                return nil
        }

        let rows = httpResponse.allHeaderFields.map { (header) -> Row in
            return Row("\(header.key)", "\(header.value)")
        }

        return Row("Headers", sections: [Section("Headers", rows)])
    }

    private func generateResponseTextRow() -> Row? {
        guard let log = Session.current.selectedLog,
            let data = log.data else {
                return nil
        }

        if data.isEmpty {
            return nil
        }

        return Row("Text", identifier: "ResponseTextViewController")
    }

    private func generateResponseBoxyRow() -> Row? {
        guard let log = Session.current.selectedLog,
            let data = log.data else {
                return nil
        }

        if data.isEmpty {
            return nil
        }

        guard let contentType = ContentDataViewController.supportedContentTypeName(for: log.overview.contentType) else {
            return nil
        }

        return Row(contentType.rawValue, identifier: "ResponseBodyViewController")
    }

}
