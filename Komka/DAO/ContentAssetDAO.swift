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
    private var assets: [ContentAsset] = []
    private var scenarioAsset: ContentAsset?
    
    var publishAssets = PublishSubject<[ContentAsset]>()
    
    init() {
        self.ckHelper = CKHelper.shared
    }
    
    // TODO: delete func ini, filter dari func yang bawah
    func fetchScenarioCoverAsset(scenarioRecordId: CKRecord.ID, completion: @escaping (ContentAsset?, FetchError?) -> Void) {
        let step = AssetStepType.Cover.rawValue
        let genderPredicate = NSPredicate(format: "step == %@", step)
        let scenarioPredicate = NSPredicate(format: "scenario == %@", scenarioRecordId)
        
        let assetPredicate = NSCompoundPredicate(type: .and, subpredicates: [genderPredicate, scenarioPredicate])
        
        let queryAsset = CKQuery(recordType: RecordType.Asset.rawValue, predicate: assetPredicate)
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
                else {
                    completion(nil, FetchError.missingData(recordType: RecordType.Asset))
                    return
                }
                
                self.scenarioAsset = ContentAsset(id: returnedRecordID, title: imageTitle, gender: imageGender, scenario: scenarioReference, step: imageStep, image: scenarioImage, part: imagePart)
                
            case .failure(_):
                completion(nil, FetchError.failedQuery(recordType: RecordType.Asset))
            }
        }
        
        queryOperationAsset.queryResultBlock = { result in
            switch result {
            case .success(_):
                completion(self.scenarioAsset, nil)
            case.failure(_):
                completion(nil, FetchError.failedQuery(recordType: RecordType.Asset))
            }
        }
        
        ckHelper.publicDB.add(queryOperationAsset)
    }
    
    func fetchCoverAsset(){
        let step = AssetStepType.Cover.rawValue
        let assetPredicate = NSPredicate(format: "step == %@", step)
        
        let queryAsset = CKQuery(recordType: RecordType.Asset.rawValue, predicate: assetPredicate)
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
        assets = []
        
        let userGenderPredicate = NSPredicate(format: "gender == %@", userGender)
        let scenarioPredicate = NSPredicate(format: "scenario == %@", scenarioRecordId)
        
        let assetPredicate = NSCompoundPredicate(type: .and, subpredicates: [userGenderPredicate, scenarioPredicate])
        
        let queryAsset = CKQuery(recordType: RecordType.Asset.rawValue, predicate: assetPredicate)
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
                else {
                    completion(nil, FetchError.missingData(recordType: RecordType.Asset))
                    return
                }
                
                self.assets.append(ContentAsset(id: returnedRecordID, title: imageTitle, gender: imageGender, scenario: scenarioReference, step: imageStep, image: scenarioImage, part: imagePart))
                
            case .failure(_):
                completion(nil, FetchError.failedQuery(recordType: RecordType.Asset))
            }
        }
        
        queryOperationAsset.queryResultBlock = { result in
            switch result {
            case .success(_):
                completion(self.assets, nil)
            case.failure(_):
                completion(nil, FetchError.failedQuery(recordType: RecordType.Asset))
            }
        }
        
        ckHelper.publicDB.add(queryOperationAsset)
    }
}
