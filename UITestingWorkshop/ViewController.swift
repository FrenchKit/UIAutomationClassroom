//
//  ViewController.swift
//  UITestingWorkshop
//
//  Created by Dmitry Bespalov on 21.08.17.
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var testingLabel: UILabel!
    @IBOutlet weak var showTableButton: UIButton!
    @IBOutlet weak var showCollectionButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        let args = ProcessInfo.processInfo.arguments
        testingLabel.isHidden = !args.contains("ui_testing")
        testingLabel.accessibilityIdentifier = "testingLabel"
        showTableButton.accessibilityIdentifier = "showTableButton"
        showCollectionButton.accessibilityIdentifier = "showCollectionButton"
        showCollectionButton.accessibilityValue = "OPEN"
        localize()
    }

    func localize() {
        testingLabel.text = NSLocalizedString("main.testing", comment: "Test in progress")
        showTableButton.setTitle(NSLocalizedString("main.table.button", comment: "Show table view"), for: .normal)
        showCollectionButton.setTitle(NSLocalizedString("main.collection.button", comment: "Show collection"), for: .normal)
    }

}

