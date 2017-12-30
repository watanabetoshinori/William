//
//  NetworkMonitorController.swift
//  NetworkMonitor
//
//  Created by Toshinori Watanabe on 12/29/17.
//  Copyright © 2017 Toshinori Watanabe. All rights reserved.
//

import UIKit

class NetworkMonitorController: UIViewController, UITableViewDataSource, UITableViewDelegate, SessionDelegate {

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet var emptyView: UIView!

    @IBOutlet weak var toolBar: UIToolbar!

    @IBOutlet var recordingButton: UIBarButtonItem!

    @IBOutlet var notRecordingButton: UIBarButtonItem!

    @IBOutlet var clearButton: UIBarButtonItem!

    private var isInitialized = false

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        Session.current.delegate = self

        updateRecordButtonState()
        updateClerButtonState()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if isInitialized == false {
            isInitialized = true

            // Scroll to bottom
            let numberOfRows = tableView.numberOfRows(inSection: 0)
            if numberOfRows > 0 {
                let indexPath = IndexPath(row: numberOfRows - 1, section: 0)
                tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }
        }
    }

    deinit {
        Session.current.delegate = nil
    }

    // MARK: - Actions

    @IBAction func clearTapped(_ sender: Any) {
        Session.current.clear()
    }

    @IBAction func startRecordingTapped(_ sender: Any) {
        Session.current.isRecording = true
        updateRecordButtonState()
    }

    @IBAction func stopRecordingTapped(_ sender: Any) {
        Session.current.isRecording = false
        updateRecordButtonState()
    }

    // MARK: - TableView Datasouce

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = Session.current.logs.count

        tableView.backgroundView = numberOfRows == 0 ? emptyView : nil

        return numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let log = Session.current.logs[indexPath.row]
        let main = log.main

        let cell = tableView.dequeueReusableCell(withIdentifier: "NetworkLogCell", for: indexPath) as! NetworkLogCell

        cell.resourceLabel.textColor = log.logType.color ?? .black
        cell.resourceLabel.text = main.resource
        cell.pathLabel.text = main.path
        cell.startTimeLabel.text = log.requestStartDete.string("H:mm:ss")
        cell.loadingBackgroundView.alpha = log.isLoading ? 1 : 0

        return cell
    }

    @available(iOS 11.0, *)
    @available(iOSApplicationExtension 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let clearAction = UIContextualAction(style: .destructive, title: "Clear") { (_, _, completion) in
            let log = Session.current.logs[indexPath.row]
            Session.current.clear(log)
            completion(true)
        }

        return UISwipeActionsConfiguration(actions: [clearAction])
    }

    // MARK: - TableView Delegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let log = Session.current.logs[indexPath.row]
        Session.current.selectedLog = log

        let viewController = storyboard!.instantiateViewController(withIdentifier: "KeyValueViewController") as! KeyValueViewController
        viewController.sections = generateOverviewSections()
        navigationController?.pushViewController(viewController, animated: true)
    }

    // MARK: - Session Delegate

    func session(_ session: Session, didInsertLog log: NetworkLog, at index: Int) {
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .top)
        tableView.endUpdates()

        updateClerButtonState()
    }

    func session(_ session: Session, didModifyLog log: NetworkLog, at index: Int) {
        tableView.beginUpdates()
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
        tableView.endUpdates()
    }

    func session(_ session: Session, didDeleteLog log: NetworkLog, at index: Int) {
        tableView.beginUpdates()
        tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
        tableView.endUpdates()

        updateClerButtonState()
    }

    func sessionDidClearLogs(_ session: Session) {
        tableView.reloadData()

        updateClerButtonState()
    }

    // MARK: - Controls

    private func updateRecordButtonState() {
        var items = toolBar.items ?? []

        if Session.current.isRecording {
            if let index = items.index(of: notRecordingButton) {
                items[index] = self.recordingButton
            }
        } else {
            if let index = items.index(of: recordingButton) {
                items[index] = self.notRecordingButton
            }
        }

        toolBar.items = items
    }

    private func updateClerButtonState() {
        clearButton.isEnabled = !Session.current.logs.isEmpty
    }

}
