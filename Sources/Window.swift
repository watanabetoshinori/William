//
//  Window.swift
//  Window
//
//  Created by Toshinori Watanabe on 12/29/17.
//  Copyright © 2017 Toshinori Watanabe. All rights reserved.
//

import UIKit

class Window: UIWindow, UIPopoverPresentationControllerDelegate {

    // MARK: - Initializing a UIWindow

    override init(frame: CGRect) {
        super.init(frame: frame)

        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        initialize()
    }

    convenience init() {
        self.init(frame: .zero)

        initialize()
    }

    private func initialize() {
        windowLevel = UIWindowLevelStatusBar + 100
    }

    // MARK: - UIPopoverPresentationController delegate

    public func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        isHidden = true
    }

}
