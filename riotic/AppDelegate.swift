//
//  AppDelegate.swift
//  riotic
//
//  Created by Joakim Ahlén on 2016-10-12.
//  Copyright © 2016 Digistrada S.L. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {

	}

	func applicationWillFinishLaunching(_ notification: Notification) {
		if UserDefaults.standard.bool(forKey: "hasLaunchedBefore") {
			print("App has launched before")
		} else {
			UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")

			UserDefaults.standard.set(true, forKey: "WebContinuousSpellCheckingEnabled")
			UserDefaults.standard.set(true, forKey: "WebKitDeveloperExtras")
		}
	}

    func applicationWillTerminate(_ aNotification: Notification) {

    }

}
