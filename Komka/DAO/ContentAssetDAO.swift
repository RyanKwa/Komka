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
    private let ckHelper: CKHelper
    var assets: [ContentAsset] = []
    
    var publishAssets = PublishSubject<[ContentAsset]>()
    
    init() {
        self.ckHelper = CKHelper.shared
    }
    
    func fetchCoverAssets(){
        let step = AssetStepType.Cover.rawValue
        let gender = NSUbiquitousKeyValueStore.default.hasChooseGender
        
        let assetPredicate = NSPredicate(format: "step == %@", step)
        let genderPredicate = NSPredicate(format: "gender == %@", gender)
        
        let fetchPredicate = NSCompoundPredicate(type: .and, subpredicates: [assetPredicate, genderPredicate])
        let queryAsset = CKQuery(recordType: RecordType.Asset.rawValue, predicate: fetchPredicate)
        queryAsset.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        let queryOperationAsset = CKQueryOperation(query: queryAsset)
        
        queryOperationAsset.recordMatchedBlock = { (returnedRecordID, returnedScenario) in
            switch returnedScenario{
            case .success(let record):
                guard
                    let imageTitle = record["title"] as? String,
                    let imageGender = record["gender"] as? String,
                    let scenarioReference = record["scenario"] as? CKRecord.Reference,
                    let imageStep = record["step"] as? String,
                    let scenarioImage = record["image"] as? CKAsset,
                    let imagePart = record["part"] as? String
                else {
                    self.publishAssets.onError(FetchError.missingData(recordType: RecordType.Asset))
                    return
                }
                
                self.assets.append(ContentAsset(id: returnedRecordID, title: imageTitle, gender: imageGender, scenario: scenarioReference, step: imageStep, image: scenarioImage, part: imagePart))
                
                
            case .failure(_):
                self.publishAssets.onError(FetchError.failedQuery(recordType: RecordType.Asset))
            }
        }
        
        queryOperationAsset.queryResultBlock = { result in
            switch result {
            case .success(_):
                self.publishAssets.onNext(self.assets)
                self.publishAssets.onCompleted()
            case.failure(_):
                self.publishAssets.onError(FetchError.failedQuery(recordType: RecordType.Asset))
            }
        }
        self.ckHelper.publicDB.add(queryOperationAsset)
    }
    
    func fetchAllScenarioAssets(scenarioRecordId: CKRecord.ID, userGender: String, completion: @escaping ([ContentAsset]?, FetchError?) -> Void) {
        var scenarioAssets: [ContentAsset] = []
        
        let userGenderPredicate = NSPredicate(format: "gender == %@", userGender)
        let scenarioPredicate = NSPredicate(format: "scenario == %@", scenarioRecordId)
        
        let assetPredicate = NSCompoundPredicate(type: .and, subpredicates: [userGenderPredicate, scenarioPredicate])
        
        let queryAsset = CKQuery(recordType: RecordType.Asset.rawValue, predicate: assetPredicate)
        let queryOperationAsset = CKQueryOperation(query: queryAsset)
        queryOperationAsset.qualityOfService = .userInitiated
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
                else {
                    completion(nil, FetchError.missingData(recordType: RecordType.Asset))
                    return
                }
                
                scenarioAssets.append(ContentAsset(id: returnedRecordID, title: imageTitle, gender: imageGender, scenario: scenarioReference, step: imageStep, image: scenarioImage, part: imagePart))
                
            case .failure(_):
                completion(nil, FetchError.failedQuery(recordType: RecordType.Asset))
            }
        }
        
        queryOperationAsset.queryResultBlock = { result in
            switch result {
            case .success(_):
                completion(scenarioAssets, nil)
            case.failure(_):
                completion(nil, FetchError.failedQuery(recordType: RecordType.Asset))
            }
        }
        
        ckHelper.publicDB.add(queryOperationAsset)
    }
}
