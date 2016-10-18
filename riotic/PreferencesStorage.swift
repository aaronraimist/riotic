//
//  PreferencesStorage.swift
//  riotic
//
//  Created by Joakim Ahlén on 2016-10-18.
//  Copyright © 2016 Digistrada S.L. All rights reserved.
//

import Foundation

protocol PreferencesStorageDelegate: class {
    func didConfigChange(sender: PreferencesStorage)
}

class PreferencesStorage {
    let myFileName = "Preferences"
    var myDefaults: UserDefaults?
    weak var delegate:PreferencesStorageDelegate?
    
    static let sharedInstance: PreferencesStorage = {
        let instance = PreferencesStorage()
        
        instance.readPreferencesList()
        
        return instance
    }()
    
    func readPreferencesList() {
        myDefaults = UserDefaults.standard
        
        if (!self.hasPreferences()) {
            self.loadDefaults();
        }
    }
    
    func store(key: String, value: String) {
        let newDict = NSMutableDictionary(dictionary: self.preferences()!, copyItems: true)
        newDict.setObject(value, forKey: key as NSCopying)
        myDefaults?.set(newDict, forKey: "preferences")
    }
    
    func get(key: String) -> String {
        return self.preferences()![key] as! String
    }
    
    func preferences() -> [String : Any]? {
        return myDefaults!.dictionary(forKey: "preferences")!
    }
    
    func hasPreferences() -> Bool {
        return self.preferences() != nil
    }
    
    func loadDefaults() {
        let defaultsPath = Bundle.main.path(forResource: self.myFileName, ofType: "plist")
        let defaultsStore = NSMutableDictionary(contentsOfFile: defaultsPath!)!
        myDefaults?.set(defaultsStore, forKey: "preferences")
    }
    
    func save() {
        myDefaults?.synchronize()
        if (delegate != nil) {
            delegate!.didConfigChange(sender: self)
        }
    }
}

