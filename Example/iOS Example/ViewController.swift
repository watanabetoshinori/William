//
//  ViewController.swift
//  iOS Example
//
//  Created by Toshinori Watanabe on 12/29/17.
//  Copyright © 2017 Toshinori Watanabe. All rights reserved.
//

import UIKit
import WebKit
import William

class ViewController: UIViewController {

    @IBOutlet weak var baseView: UIView!

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        let webView = WKWebView(frame: baseView.frame)
        baseView.addSubview(webView)

        let url = URL(string: "https://www.google.com")!
        let request = URLRequest(url: url)
        webView.load(request)
    }

    // MARK: - Shake

    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if event?.subtype == .motionShake {
            William.show()
        }
    }

}
