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

    override func viewDidLoad() {
        super.viewDidLoad()
        let args = ProcessInfo.processInfo.arguments
        testingLabel.isHidden = !args.contains("ui_testing")
        testingLabel.accessibilityIdentifier = "testingLabel"
    }

}

