//
//  AppDelegate.swift
//  UITestingWorkshop
//
//  Created by Dmitry Bespalov on 21.08.17.
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        if let mockServerAddress = LaunchArgument.serverAddress, let testID = LaunchArgument.uiTestID {
            // pass mock address and testID to your api client implementation
            print(mockServerAddress + " " + testID)
        }

        return true
    }

}

