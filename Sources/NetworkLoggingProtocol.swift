//
//  NetworkLoggingProtocol.swift
//  NetworkMonitor
//
//  Created by Toshinori Watanabe on 12/29/17.
//  Copyright © 2017 Toshinori Watanabe. All rights reserved.
//

import UIKit

class NetworkLoggingProtocol: URLProtocol, NSURLConnectionDelegate, NSURLConnectionDataDelegate {

    static let trackingPropertyKey = "NetworkLoggingProtocol"

    static let supportedSchemes = ["http", "https"]

    private var connection: NSURLConnection!

    private var loggingID: String?

    private var loggingRequest: URLRequest?

    private var loggingResponse: URLResponse?

    private var loggingRequestStartDate: Date?

    private var loggingRequestEndDate: Date?

    private var loggingResponseStartDate: Date?

    private var loggingResponseEndDate: Date?

    private var loggingData: Data?

    private var loggingError: Error?

    // MARK: - URL protocol methods

    override public class func canInit(with request: URLRequest) -> Bool {
        if URLProtocol.property(forKey: NetworkLoggingProtocol.trackingPropertyKey, in: request) != nil {
            return false
        }

        if let scheme = request.url?.scheme,
            supportedSchemes.contains(scheme) {
            return true
        }

        return false
    }

    override public class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    // swiftlint:disable identifier_name
    override public class func requestIsCacheEquivalent(_ a: URLRequest, to toRequest: URLRequest) -> Bool {
        return super.requestIsCacheEquivalent(a, to: toRequest)
    }

    override public func startLoading() {
        loggingID = UUID().uuidString
        loggingData = Data()
        loggingRequestStartDate = Date()
        loggingRequest = request

        outputLog()

        guard let mutableRequest = (self.request as NSURLRequest).mutableCopy() as? NSMutableURLRequest else {
            return
        }

        URLProtocol.setProperty(true, forKey: NetworkLoggingProtocol.trackingPropertyKey, in: mutableRequest)
        connection = NSURLConnection(request: mutableRequest as URLRequest, delegate: self)
    }

    override public func stopLoading() {
        if self.connection != nil {
            self.connection.cancel()
        }
        self.connection = nil
    }

    // MARK: - NSURLConnectionDelegate, NSURLConnectionDataDelegate

    func connection(_ connection: NSURLConnection, willSend request: URLRequest, redirectResponse response: URLResponse?) -> URLRequest? {
        if let response = response,
            let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode >= 300,
                httpResponse.statusCode < 400 {
                self.client?.urlProtocol(self, wasRedirectedTo: request, redirectResponse: response)
                return nil
            }
        }

        return request
    }

    public func connection(_ connection: NSURLConnection, didReceive response: URLResponse) {
        loggingRequestEndDate = Date()
        loggingResponseStartDate = Date()
        loggingResponse = response

        outputLog()

        self.client!.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
    }

    public func connection(_ connection: NSURLConnection, didReceive data: Data) {
        loggingData?.append(data)

        self.client!.urlProtocol(self, didLoad: data)
    }

    public func connectionDidFinishLoading(_ connection: NSURLConnection) {
        loggingResponseEndDate = Date()

        outputLog()

        self.client!.urlProtocolDidFinishLoading(self)
    }

    public func connection(_ connection: NSURLConnection, didFailWithError error: Error) {
        loggingResponseEndDate = Date()

        loggingError = error

        outputLog()

        self.client!.urlProtocol(self, didFailWithError: error)
    }

    // MARK: - Logging

    private func outputLog() {
        let log = NetworkLog(id: loggingID!,
                             requestStartDete: loggingRequestStartDate!,
                             requestEndDate: loggingRequestEndDate,
                             responseStartDete: loggingResponseStartDate,
                             responseEndDate: loggingResponseEndDate,
                             request: loggingRequest!,
                             response: loggingResponse,
                             data: loggingData,
                             error: loggingError)

        DispatchQueue.main.async {
            Session.current.output(log)
        }
    }

}
