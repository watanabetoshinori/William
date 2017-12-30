//
//  KeyValueViewController.swift
//  NetworkMonitor
//
//  Created by Toshinori Watanabe on 12/29/17.
//  Copyright © 2017 Toshinori Watanabe. All rights reserved.
//

import UIKit

struct Section {

    let title: String?

    let rows: [Row]

    init(_ title: String?, _ rows: [Row]) {
        self.title = title
        self.rows = rows
    }

}

struct Row {

    let key: String

    let value: String?

    let identifier: String?

    let sections: [Section]

    init(_ key: String, _ value: String? = nil, identifier: String? = nil, sections: [Section] = []) {
        self.key = key
        self.value = value
        self.identifier = identifier
        self.sections = sections
    }

}

class KeyValueViewController: UITableViewController {

    var sections = [Section]()

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        title = sections.first?.title
    }

    // MARK: - TableView data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            // The title of the first section is used as the title of ViewController
            return nil
        }
        return sections[section].title
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].rows.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = sections[indexPath.section].rows[indexPath.row]

        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.text = row.value ?? ""
        let estimateTextSize = label.sizeThatFits(CGSize(width: tableView.frame.size.width / 2,
                                                         height: CGFloat.greatestFiniteMagnitude))

        if estimateTextSize.height < 36 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SingleLineCell", for: indexPath) as! KeyValueItemCell

            cell.keyLabel.text = row.key
            cell.valueLabel.text = row.value

            if row.sections.isEmpty, row.identifier == nil {
                cell.selectionStyle = .none
                cell.accessoryType = .none
            } else {
                cell.selectionStyle = .default
                cell.accessoryType = .disclosureIndicator
            }
            return cell

        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MultiLineCell", for: indexPath) as! KeyValueItemCell

            cell.keyLabel.text = row.key
            cell.valueTextView.text = row.value

            cell.selectionStyle = .none
            cell.accessoryType = .none

            return cell
        }
    }

    // MARK: - TableView delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = sections[indexPath.section].rows[indexPath.row]

        if row.sections.isEmpty, row.identifier == nil {
            return
        }

        if let identifer = row.identifier {
            let viewController = storyboard!.instantiateViewController(withIdentifier: identifer)
            navigationController?.pushViewController(viewController, animated: true)
        } else {
            let viewController = storyboard!.instantiateViewController(withIdentifier: "KeyValueViewController") as! KeyValueViewController
            viewController.sections = row.sections
            navigationController?.pushViewController(viewController, animated: true)
        }
    }

    override func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        let row = sections[indexPath.section].rows[indexPath.row]

        if row.value != nil {
            if action == Selector("copy:") {
                return true
            }
        }

        return false
    }

    override func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
        if action == Selector("copy:") {
            let row = sections[indexPath.section].rows[indexPath.row]
            UIPasteboard.general.string = row.value
        }
    }

}
