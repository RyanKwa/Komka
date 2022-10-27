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
    static let instance = ScenarioDAO()

    var ckHelper = CloudKitHelper.shared
    var scenarios: [Scenario] = []
    var assets: [ContentAsset] = []
    
    var scenariosPublisher = PublishSubject<[Scenario]>()
    var assetsPublisher = PublishSubject<[ContentAsset]>()
    
    func fetchAssetData(){
        let step = "Cover"
        let assetPredicate = NSPredicate(format: "step == %@", step)
        
        let queryAsset = CKQuery(recordType: "Asset", predicate: assetPredicate)
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
                else { return }
                
                self.assets.append(ContentAsset(id: returnedRecordID, title: imageTitle, gender: imageGender, scenario: scenarioReference, step: imageStep, image: scenarioImage))
                
                
            case .failure(let error):
                print("Error recordMatchedBlock: \(error)")
            }
        }
        
        queryOperationAsset.queryResultBlock = { _ in
            self.assetsPublisher.onNext(self.assets)
            self.assetsPublisher.onCompleted()
        }
        self.ckHelper.db.add(queryOperationAsset)
    }
    
    
    func fetchScenarioData(){
        let queryScenario = CKQuery(recordType: "Scenario", predicate: NSPredicate(value: true))
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
                else { return }
                
                self.scenarios.append(Scenario(id: returnedRecordID, title: scenarioTitle, isCompleted: scenarioStatus, sentence: scenarioSentence, level: scenarioLevel, reward: nil, multipleChoice: nil, wordImitations: []))
                
            case .failure(let error):
                print("Error recordMatchedBlock: \(error)")
            }
        }
        
        queryOperationScenario.queryResultBlock = { _ in
            self.scenariosPublisher.onNext(self.scenarios)
            self.scenariosPublisher.onCompleted()
        }
        self.ckHelper.db.add(queryOperationScenario)
        
    }
    
}
