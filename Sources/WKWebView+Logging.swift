//
//  WKWebView+Logging.swift
//  NetworkMonitor
//
//  Created by Toshinori Watanabe on 12/29/17.
//  Copyright © 2017 Toshinori Watanabe. All rights reserved.
//

import UIKit
import WebKit

extension WKWebView {

    class var isLoggingEnabled: Bool {
        get {
            return WKWebView.isProtocolRegisterd
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

            guard let controller = WKWebView.contextControllerClass else {
                fatalError("browsingContextController not found")
            }

            guard let `class` = object_getClass(controller) as? NSObjectProtocol else {
                fatalError("class not cast to NSObjectProtocol")
            }

            if newValue {
                `class`.perform(Selector(("registerSchemeForCustomProtocol:")), with: "http")
                `class`.perform(Selector(("registerSchemeForCustomProtocol:")), with: "https")
                WKWebView.isProtocolRegisterd = true
            } else {
                `class`.perform(Selector(("unregisterSchemeForCustomProtocol:")), with: "http")
                `class`.perform(Selector(("unregisterSchemeForCustomProtocol:")), with: "https")
                WKWebView.isProtocolRegisterd = false
            }
        }
    }

    static var isProtocolRegisterd = false

    private class var contextControllerClass: NSObject? {
        return WKWebView().value(forKey: "browsingContextController") as? NSObject
    }

}
