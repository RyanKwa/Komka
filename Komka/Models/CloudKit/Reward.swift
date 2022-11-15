//
//  Reward.swift
//  Komka
//
//  Created by Ryan Vieri Kwa on 13/10/22.
//

import CloudKit

import Foundation

struct Reward {
    let id: CKRecord.ID
    let title: String
    let amount: Int?
    let image: CKAsset?
}
