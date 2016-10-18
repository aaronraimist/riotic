//
//  Preferences.swift
//  riotic
//
//  Created by Joakim Ahlén on 2016-10-16.
//  Copyright © 2016 Digistrada S.L. All rights reserved.
//

import Cocoa

class Preferences: NSViewController {

    var prefs = PreferencesStorage.sharedInstance
    
    @IBOutlet weak var riotClientUrl: NSTextField!
    @IBAction func loadDefaultsButtonClick(_ sender: AnyObject) {
        prefs.loadDefaults()
        self.setUIvalues()
    }

    @IBAction func cancelButtonClick(_ sender: AnyObject) {
        dismissViewController(self)
    }
    
    @IBAction func saveButtonClick(_ sender: AnyObject) {
        prefs.store(key: "riotClientUrl", value: riotClientUrl.stringValue)
        prefs.save()
        dismissViewController(self)
    }
    
    func setUIvalues() {
        riotClientUrl.stringValue = prefs.get(key: "riotClientUrl")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setUIvalues()
    }
    
}
