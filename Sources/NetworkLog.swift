//
//  NetworkLog.swift
//  NetworkMonitor
//
//  Created by Toshinori Watanabe on 12/29/17.
//  Copyright © 2017 Toshinori Watanabe. All rights reserved.
//

import UIKit

enum LogType {

    case download

    case upload

    case error

    var color: UIColor? {
        switch self {
        case .download:
            // Blue
            return UIColor(red: 9/255, green: 80/255, blue: 208/255, alpha: 1)
        case .upload:
            // Green
            return UIColor(red: 45/255, green: 167/255, blue: 196/255, alpha: 1)
        case .error:
            // Red
            return UIColor(red: 179/255, green: 0/255, blue: 3/255, alpha: 1)
        }
    }
}

struct NetworkLog {

    let id: String

    let requestStartDete: Date

    let requestEndDate: Date?

    let responseStartDete: Date?

    let responseEndDate: Date?

    let request: URLRequest

    let response: URLResponse?

    let data: Data?

    let error: Error?

    var logType: LogType {
        if error != nil {
            return .error
        }

        if ["post", "put", "patch", "delete"].contains(request.httpMethod?.lowercased() ?? "") {
            return .upload
        } else {
            return .download
        }
    }

    var isLoading: Bool {
        return responseEndDate == nil
    }

}
