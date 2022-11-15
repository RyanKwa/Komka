//
//  NSUbiquitousKeyValueStore+Ext.swift
//  Komka
//
//  Created by Minawati on 11/10/22.
//

import Foundation

extension NSUbiquitousKeyValueStore {
    private enum KeyValueStore: String {
        case hasChooseGender
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
}
