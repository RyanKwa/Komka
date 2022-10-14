//
//  Asset.swift
//  Komka
//
//  Created by Ryan Vieri Kwa on 13/10/22.
//

import CloudKit
import Foundation

struct Asset {
    let id: CKRecord.ID?
    let title: String?
    let gender: String?
    let scenario: CKRecord.Reference?
    let step: String?
    let image: [CKAsset]?
}
