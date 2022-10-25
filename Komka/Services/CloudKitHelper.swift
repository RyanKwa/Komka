//
//  CloudKitHelper.swift
//  Komka
//
//  Created by Evelin Evelin on 17/10/22.
//

import CloudKit
import UIKit

class CloudKitHelper {
    static let shared = CloudKitHelper()
    
    let db = CKContainer.default().publicCloudDatabase
   
}
