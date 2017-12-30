//
//  William.swift
//  William
//
//  Created by Toshinori Watanabe on 12/29/17.
//  Copyright © 2017 Toshinori Watanabe. All rights reserved.
//

import UIKit

public class William: NSObject {

    lazy private var window: Window = {
        let viewController = UIViewController()
        viewController.view.frame = UIScreen.main.bounds
        viewController.view.backgroundColor = .clear

        let window = Window(frame: UIScreen.main.bounds)
        window.rootViewController = viewController
        return window
    }()

    // MARK: - Initializing a Singleton

    static private let main = William()

    override private init() {

    }

    // MARK: - Show / Hide Panel

    @objc public class func show() {
        if William.main.window.isHidden == false {
            return
        }

        William.main.window.isHidden = false

        let bundle = Bundle(for: William.self)
        let storyboard = UIStoryboard(name: "NetworkMonitor", bundle: bundle)

        if let rootViewController = William.main.window.rootViewController,
            let navigationController = storyboard.instantiateInitialViewController() as? UINavigationController {

            navigationController.topViewController?.title = "William"

            navigationController.topViewController?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close",
                                                                                                        style: .plain,
                                                                                                        target: William.self,
                                                                                                        action: #selector(William.hide))

            if rootViewController.traitCollection.horizontalSizeClass == .regular,
                rootViewController.traitCollection.verticalSizeClass == .regular {

                navigationController.modalPresentationStyle = .popover
                navigationController.preferredContentSize = CGSize(width: 320, height: 480)
                navigationController.popoverPresentationController?.delegate = William.main.window as! UIPopoverPresentationControllerDelegate
                navigationController.popoverPresentationController?.sourceView = rootViewController.view
                navigationController.popoverPresentationController?.sourceRect = CGRect(origin: CGPoint(x: rootViewController.view.frame.size.width / 2, y: 0),
                                                                                  size: .zero)
                navigationController.popoverPresentationController?.permittedArrowDirections = .any
            }

            William.main.window.rootViewController?.present(navigationController, animated: true, completion: nil)
        }
    }

    @objc public class func hide() {
        if William.main.window.isHidden {
            return
        }

        William.main.window.rootViewController?.dismiss(animated: true, completion: {
            William.main.window.isHidden = true
        })
    }

}
