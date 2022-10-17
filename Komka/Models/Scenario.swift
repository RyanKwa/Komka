//
//  Scenario.swift
//  Komka
//
//  Created by Ryan Vieri Kwa on 13/10/22.
//

import CloudKit
import Foundation

struct Scenario {
    //liat real case pengunaannya gmn, mana wajib mana ga
    let id: CKRecord.ID
    let title: String
    let isCompleted: Bool
    let sentence: String
    let level: CKRecord.Reference
    let reward: Reward?
    let multipleChoice: MultipleChoice
    let imitating: [WordImitation]
}
