//
//  NetworkLog+Content.swift
//  NetworkMonitor
//
//  Created by Toshinori Watanabe on 12/29/17.
//  Copyright © 2017 Toshinori Watanabe. All rights reserved.
//

import UIKit

extension NetworkLog {

    var content: NetworkLogContent {
        return NetworkLogContent(log: self)
    }

}

struct NetworkLogContent {

    let log: NetworkLog

    var requestContentType: String {
        if let value = log.request.allHTTPHeaderFields?["Content-Type"] {
            return value
        }

        return "-"
    }

}
