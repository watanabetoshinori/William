//
//  RequestBodyViewController.swift
//  NetworkMonitor
//
//  Created by Toshinori Watanabe on 12/29/17.
//  Copyright © 2017 Toshinori Watanabe. All rights reserved.
//

import UIKit

class RequestBodyViewController: UIViewController {

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.destination, segue.identifier) {
        case (let viewController as ContentDataViewController, "ContainerDidSet"?):
            guard let log = Session.current.selectedLog else {
                return
            }

            viewController.data = log.request.httpBody ?? Data()
            viewController.contentType = log.content.requestContentType
            viewController.ownerViewController = self
        default:
            break
        }
    }

}
