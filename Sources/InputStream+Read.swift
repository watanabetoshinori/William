//
//  InputStream+Read.swift
//  NetworkMonitor
//
//  Created by Watanabe Toshinori on 1/5/18.
//

import Foundation

extension InputStream {

    func read() -> Data {
        var result = Data()
        var buffer = [UInt8](repeating: 0, count: 4096)

        open()

        var amount = 0
        repeat {
            amount = read(&buffer, maxLength: buffer.count)
            if amount > 0 {
                result.append(buffer, count: amount)
            }
        } while amount > 0

        close()

        return result
    }

}
