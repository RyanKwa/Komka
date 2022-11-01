//
//  ContentAssetDAO.swift
//  Komka
//
//  Created by Minawati on 24/10/22.
//

import Foundation
import CloudKit
import RxSwift

class ContentAssetDAO {
    static let shared = ContentAssetDAO()
    
    private let cloudKitHelper: CKHelper
    private var assets: [ContentAsset] = []
    
    var publishAssets = PublishSubject<[ContentAsset]>()
    
    init() {
        self.cloudKitHelper = CKHelper.shared
    }
    
    func fetchScenarioCoverAsset(scenarioRecordId: CKRecord.ID) {
        let step = "Cover"
        let genderPredicate = NSPredicate(format: "step == %@", step)
        let scenarioPredicate = NSPredicate(format: "scenario == %@", scenarioRecordId)
        
        let assetPredicate = NSCompoundPredicate(type: .and, subpredicates: [genderPredicate, scenarioPredicate])
        
        let queryAsset = CKQuery(recordType: "Asset", predicate: assetPredicate)
        let queryOperationAsset = CKQueryOperation(query: queryAsset)

        queryOperationAsset.recordMatchedBlock = { (returnedRecordID, returnedAsset) in
            switch returnedAsset {
            case .success(let record):
                guard
                    let imageTitle = record["title"] as? String,
                    let imageGender = record["gender"] as? String,
                    let scenarioReference = record["scenario"] as? CKRecord.Reference,
                    let imageStep = record["step"] as? String,
                    let scenarioImage = record["image"] as? CKAsset,
                    let imagePart = record["part"] as? String
                else { return }
                
                self.assets.append(ContentAsset(id: returnedRecordID, title: imageTitle, gender: imageGender, scenario: scenarioReference, step: imageStep, image: scenarioImage, part: imagePart))
                
            case .failure(let error):
                print("Error recordMatchedBlock: \(error)")
            }
        }
        
        queryOperationAsset.queryResultBlock = { _ in
            self.publishAssets.onNext(self.assets)
        }
        
        cloudKitHelper.db.add(queryOperationAsset)
    }
    
    func fetchAllScenarioAssets(scenarioRecordId: CKRecord.ID, userGender: String) {
        assets = []
        
        let userGenderPredicate = NSPredicate(format: "gender == %@", userGender)
        let scenarioPredicate = NSPredicate(format: "scenario == %@", scenarioRecordId)
        
        let assetPredicate = NSCompoundPredicate(type: .and, subpredicates: [userGenderPredicate, scenarioPredicate])
        
        let queryAsset = CKQuery(recordType: "Asset", predicate: assetPredicate)
        let queryOperationAsset = CKQueryOperation(query: queryAsset)

        queryOperationAsset.recordMatchedBlock = { (returnedRecordID, returnedAsset) in
            switch returnedAsset {
            case .success(let record):
                guard
                    let imageTitle = record["title"] as? String,
                    let imageGender = record["gender"] as? String,
                    let scenarioReference = record["scenario"] as? CKRecord.Reference,
                    let imageStep = record["step"] as? String,
                    let scenarioImage = record["image"] as? CKAsset,
                    let imagePart = record["part"] as? String
                else { return }
                
                self.assets.append(ContentAsset(id: returnedRecordID, title: imageTitle, gender: imageGender, scenario: scenarioReference, step: imageStep, image: scenarioImage, part: imagePart))
                
            case .failure(let error):
                print("Error recordMatchedBlock: \(error)")
            }
        }
        
        queryOperationAsset.queryResultBlock = { _ in
            self.publishAssets.onNext(self.assets)
        }
        
        cloudKitHelper.db.add(queryOperationAsset)
    }
}
