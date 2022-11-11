//
//  MultipleChoice.swift
//  Komka
//
//  Created by Ryan Vieri Kwa on 13/10/22.
//

import CloudKit
import Foundation

struct MultipleChoice {
    let id: CKRecord.ID
    let imageCaption: String
    let question: String
    let choices: [String]
    let answer: String
}
