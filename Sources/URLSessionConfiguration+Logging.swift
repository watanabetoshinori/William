//
//  URLSessionConfiguration+Logging.swift
//  NetworkMonitor
//
//  Created by Toshinori Watanabe on 12/29/17.
//  Copyright © 2017 Toshinori Watanabe. All rights reserved.
//

import UIKit

extension URLSessionConfiguration {

    var isLoggingEnabled: Bool {
        get {
            return URLSessionConfiguration.default.protocolClasses?.contains(where: { $0 == NetworkLoggingProtocol.self }) == true
        }
        set {
            if newValue && isLoggingEnabled {
                // Already enabled
                return
            }
            if !newValue && !isLoggingEnabled {
                // Already disabled
                return
            }

            exchangeImplementation(#selector(getter: URLSessionConfiguration.protocolClasses), #selector(getter: URLSessionConfiguration.loggingProtocolClasses))

            if newValue == false {
                var protocols = URLSessionConfiguration.default.protocolClasses
                if let index = protocols?.index(where: { (protocolClass) -> Bool in
                    return protocolClass == NetworkLoggingProtocol.self
                }) {
                    protocols?.remove(at: index)
                }
                URLSessionConfiguration.default.protocolClasses = protocols
            }
        }
    }

    @objc private var loggingProtocolClasses: [AnyClass]? {
        var protocols = loggingProtocolClasses

        if protocols?.contains(where: { $0 == NetworkLoggingProtocol.self }) == false {
            protocols?.insert(NetworkLoggingProtocol.self, at: 0)
        }

        return protocols
    }

    // MARK: - Swizzing methods

    private func exchangeImplementation(_ origin: Selector, _ stub: Selector) {
        let `class` = object_getClass(URLSessionConfiguration.default)

        let originalMethod = class_getInstanceMethod(`class`, origin)
        let stubMethod = class_getInstanceMethod(`class`, stub)
        if originalMethod == nil || stubMethod == nil {
            fatalError("Failed to get instance method.")
        }
        method_exchangeImplementations(originalMethod!, stubMethod!)
    }

}
