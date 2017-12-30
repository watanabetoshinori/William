//
//  NetworkLogCell.swift
//  NetworkMonitor
//
//  Created by Toshinori Watanabe on 12/29/17.
//  Copyright © 2017 Toshinori Watanabe. All rights reserved.
//

import UIKit

class NetworkLogCell: UITableViewCell {

    @IBOutlet weak var statusImageView: UIImageView!

    @IBOutlet weak var resourceLabel: UILabel!

    @IBOutlet weak var pathLabel: UILabel!

    @IBOutlet weak var startTimeLabel: UILabel!

    @IBOutlet weak var loadingBackgroundView: UIView!

}
