//
//  ScenarioDAO.swift
//  Komka
//
//  Created by Evelin Evelin on 24/10/22.
//

import Foundation
import UIKit
import CloudKit
import RxSwift

class ScenarioDAO{
    var ckHelper = CloudKitHelper.shared
    var scenarios: [Scenario] = []
    var assets: [ContentAsset] = []
    
    var scenariosPublisher = PublishSubject<[Scenario]>()
    var assetsPublisher = PublishSubject<[ContentAsset]>()
    
    func fetchAssetData(){
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
                    let scenarioImage = record["image"] as? CKAsset
                else {
                    self.assetsPublisher.onError(FetchError.missingData(recordType: RecordType.Asset))
                    return
                }
                
                self.assets.append(ContentAsset(id: returnedRecordID, title: imageTitle, gender: imageGender, scenario: scenarioReference, step: imageStep, image: scenarioImage))
                
                
            case .failure(_):
                self.assetsPublisher.onError(FetchError.failedQuery(recordType: RecordType.Asset))
            }
        }
        
        queryOperationAsset.queryResultBlock = { result in
            switch result {
            case .success(_):
                self.assetsPublisher.onNext(self.assets)
                self.assetsPublisher.onCompleted()
            case.failure(_):
                self.assetsPublisher.onError(FetchError.failedQuery(recordType: RecordType.Asset))
            }
        }
        self.ckHelper.db.add(queryOperationAsset)
    }
    
    
    func fetchScenarioData(){
        let queryScenario = CKQuery(recordType: RecordType.Scenario.rawValue, predicate: NSPredicate(value: true))
        queryScenario.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        let queryOperationScenario = CKQueryOperation(query: queryScenario)
        
        queryOperationScenario.recordMatchedBlock = { (returnedRecordID, returnedScenario) in
            switch returnedScenario{
            case .success(let record):
                guard
                    let scenarioTitle = record["title"] as? String,
                    let scenarioStatus = record["isCompleted"] as? Bool,
                    let scenarioSentence = record["sentence"] as? String,
                    let scenarioLevel = record["level"] as? CKRecord.Reference
                else {
                    self.scenariosPublisher.onError(FetchError.missingData(recordType: RecordType.Scenario))
                    return
                }
                
                self.scenarios.append(Scenario(id: returnedRecordID, title: scenarioTitle, isCompleted: scenarioStatus, sentence: scenarioSentence, level: scenarioLevel, reward: nil, multipleChoice: nil, wordImitations: []))
                
            case .failure(_):
                self.scenariosPublisher.onError(FetchError.failedQuery(recordType: RecordType.Scenario))
            }
        }
        
        queryOperationScenario.queryResultBlock = { result in
            switch result {
            case .success(_):
                self.scenariosPublisher.onNext(self.scenarios)
                self.scenariosPublisher.onCompleted()
            case.failure(_):
                self.scenariosPublisher.onError(FetchError.failedQuery(recordType: RecordType.Scenario))
            }
        }
        self.ckHelper.db.add(queryOperationScenario)
        
    }
    
}
