//
//  NetworkLog+Main.swift
//  NetworkMonitor
//
//  Created by Toshinori Watanabe on 12/29/17.
//  Copyright © 2017 Toshinori Watanabe. All rights reserved.
//

import UIKit

extension NetworkLog {

    var main: NetworkLogMain {
        return NetworkLogMain(log: self)
    }

}

struct NetworkLogMain {

    let log: NetworkLog

    var resource: String {
        if let lastPath = log.request.url?.lastPathComponent as NSString?,
            lastPath.pathExtension.isEmpty == false {
            return lastPath as String
        }

        if let path = log.request.url?.path,
            path.isEmpty == false {
            return path
        }

        return "/"
    }

    var path: String {
        let host = log.request.url?.host ?? ""
        let path = log.request.url?.path ?? ""
        let query: String = {
            if let query = log.request.url?.query {
                return "?\(query)"
            }
            return ""
        }()

        return host + path + query
    }

}
