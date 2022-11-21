//
//  NSUbiquitousKeyValueStore+Ext.swift
//  Komka
//
//  Created by Minawati on 11/10/22.
//

import Foundation

extension NSUbiquitousKeyValueStore {
    enum KeyValueStore: String {
        case hasChooseGender
        case completedScenario
    }
    
    var hasChooseGender: String {
        get {
            return string(forKey: KeyValueStore.hasChooseGender.rawValue) ?? ""
        }
        
        set {
            set(newValue, forKey: KeyValueStore.hasChooseGender.rawValue)
            synchronize()
        }
    }
    
    var completedScenario: [String] {
        get {
            return array(forKey: KeyValueStore.completedScenario.rawValue) as? [String] ?? []
        }

        set{
            set(newValue, forKey: KeyValueStore.completedScenario.rawValue)
            synchronize()
        }
    }
}

