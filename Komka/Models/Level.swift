//
//  Level.swift
//  Komka
//
//  Created by Ryan Vieri Kwa on 13/10/22.
//

import CloudKit
import Foundation

struct Level {
    let id: CKRecord.ID?
    let title: String?
    let scenarios: [Scenario]?
}
