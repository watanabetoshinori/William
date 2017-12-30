//
//  Date+Format.swift
//  NetworkMonitor
//
//  Created by Toshinori Watanabe on 12/29/17.
//  Copyright © 2017 Toshinori Watanabe. All rights reserved.
//

import UIKit

extension Date {

    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = NSTimeZone.default
        return formatter
    }()

    func string(_ format: String) -> String {
        let formatter = Date.formatter
        formatter.dateFormat = format
        return formatter.string(from: self)
    }

}
