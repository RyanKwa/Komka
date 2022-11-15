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
        case isCompleted
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
    
    var isCompleted: Int {
        get {
            return Int(longLong(forKey: KeyValueStore.isCompleted.rawValue))
        }

        set {
            set(newValue, forKey: KeyValueStore.isCompleted.rawValue)
            synchronize()
        }
    }
}

