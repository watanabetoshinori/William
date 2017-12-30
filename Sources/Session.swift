//
//  Session.swift
//  NetworkMonitor
//
//  Created by Toshinori Watanabe on 12/29/17.
//  Copyright © 2017 Toshinori Watanabe. All rights reserved.
//

import UIKit
import WebKit

protocol SessionDelegate: class {

    func session(_ session: Session, didInsertLog log: NetworkLog, at index: Int)

    func session(_ session: Session, didModifyLog log: NetworkLog, at index: Int)

    func session(_ session: Session, didDeleteLog log: NetworkLog, at index: Int)

    func sessionDidClearLogs(_ session: Session)

}

class Session: NSObject {

    weak var delegate: SessionDelegate?

    var selectedLog: NetworkLog?

    var logs = [NetworkLog]()

    var isRecording: Bool {
        get {
            return URLSessionConfiguration.default.isLoggingEnabled
        }
        set {
            URLSessionConfiguration.default.isLoggingEnabled = newValue
            WKWebView.isLoggingEnabled = newValue
            if newValue {
                URLProtocol.registerClass(NetworkLoggingProtocol.self)
            } else {
                URLProtocol.unregisterClass(NetworkLoggingProtocol.self)
            }
        }
    }

    // MARK: - Initializing a Singleton

    static let current = Session()

    override private init() {

    }

    // MARK: - Managing logs

    func output(_ log: NetworkLog) {
        if let index = logs.index(where: { $0.id == log.id }) {
            logs[index] = log

            delegate?.session(self, didModifyLog: log, at: index)

        } else {
            logs.append(log)

            delegate?.session(self, didInsertLog: log, at: logs.count - 1)
        }
    }

    func clear(_ log: NetworkLog) {
        if let index = logs.index(where: { $0.id == log.id }) {
            logs.remove(at: index)

            delegate?.session(self, didDeleteLog: log, at: index)
        }
    }

    func clear() {
        logs.removeAll()

        delegate?.sessionDidClearLogs(self)
    }

}
