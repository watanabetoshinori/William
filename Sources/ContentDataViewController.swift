//
//  ContentDataViewController.swift
//  NetworkMonitor
//
//  Created by Toshinori Watanabe on 12/29/17.
//  Copyright © 2017 Toshinori Watanabe. All rights reserved.
//

import UIKit
import Highlightr

enum ContentType: String {
    case image = "Image"
    case json = "JSON"
    case javascript = "Javascript"
    case html = "HTML"
    case xml = "XML"
    case css = "CSS"
}

class ContentDataViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!

    @IBOutlet weak var imageView: UIImageView!

    var data: Data!

    var contentType: String!

    weak var ownerViewController: UIViewController?

    // MARK: - Supported Content Type Name

    class func supportedContentTypeName(for contentType: String) -> ContentType? {
        let type = contentType.lowercased().components(separatedBy: ";").first ?? ""

        switch type {
        case "image/png", "image/jpg", "image/jpeg", "image/bmp", "image/gif":
            return .image
        case "application/json", "text/json":
            return .json
        case "application/javascript", "text/javascript":
            return .javascript
        case "text/html":
            return .html
        case "text/xml":
            return .xml
        case "text/css":
            return .css
        default:
            break
        }

        return nil
    }

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        let typeName = ContentDataViewController.supportedContentTypeName(for: contentType)!

        ownerViewController?.title = typeName.rawValue

        switch typeName {
        case .image:
            showImage()
        case .json:
            showJSON()
        case .html, .xml, .css, .javascript:
            showSource()
        }

        ownerViewController?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                                                 target: self,
                                                                                 action: #selector(ContentDataViewController.activityTapped(_:)))
    }

    // MARK: - Display content

    func showImage() {
        guard let image = UIImage(data: data) else {
            return
        }

        imageView.image = image

        if image.size.height > imageView.frame.size.height
            || image.size.width > imageView.frame.size.width {
            imageView.contentMode = .scaleAspectFit
        } else {
            imageView.contentMode = .center
        }
    }

    func showJSON() {
        imageView.isHidden = true

        let code: String = {
            do {
                let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
                let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                if let jsonData = jsonData,
                    let string = String(data: jsonData, encoding: .utf8) {
                    return string
                }
            } catch {
                print(error)
            }

            return String(data: data, encoding: .utf8) ?? ""
        }()

        let highlightr = Highlightr()!
        let highlightedCode = highlightr.highlight(code)

        textView.attributedText = highlightedCode
        textView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }

    func showSource() {
        imageView.isHidden = true

        let code = String(data: data, encoding: .utf8) ?? ""

        let highlightr = Highlightr()!
        let highlightedCode = highlightr.highlight(code)

        textView.attributedText = highlightedCode
        textView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }

    // MARK: - Action

    @objc func activityTapped(_ sender: Any) {
        let typeName = ContentDataViewController.supportedContentTypeName(for: contentType)!

        switch typeName {
        case .image:
            guard let image = UIImage(data: data) else {
                return
            }
            let viewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            ownerViewController?.present(viewController, animated: true, completion: nil)

        case .json, .html, .xml, .css, .javascript:
            let code = String(data: data, encoding: .utf8) ?? ""
            let viewController = UIActivityViewController(activityItems: [code], applicationActivities: nil)
            ownerViewController?.present(viewController, animated: true, completion: nil)
        }
    }

}
