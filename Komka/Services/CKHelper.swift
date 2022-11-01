//
//  CKHelper.swift
//  Komka
//
//  Created by Minawati on 19/10/22.
//

import Foundation
import CloudKit

class CKHelper {
    static let shared = CKHelper()
    let db = CKContainer.default().publicCloudDatabase
}
