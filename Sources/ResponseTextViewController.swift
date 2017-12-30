//
//  ResponseTextViewController.swift
//  NetworkMonitor
//
//  Created by Watanabe Toshinori on 12/29/17.
//

import UIKit

class ResponseTextViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!

    var text: String!

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        text = {
            guard let log = Session.current.selectedLog,
                let data = log.data else {
                    return ""
            }

            return String(data: data, encoding: .utf8) ?? ""
        }()

        textView.text = text

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                            target: self,
                                                            action: #selector(ResponseTextViewController.activityTapped(_:)))
    }


    // MARK: - Action

    @objc func activityTapped(_ sender: Any) {
        let viewController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        present(viewController, animated: true, completion: nil)
    }

}
