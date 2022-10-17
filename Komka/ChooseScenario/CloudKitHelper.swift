//
//  CloudKitHelper.swift
//  Komka
//
//  Created by Evelin Evelin on 17/10/22.
//

import CloudKit
import UIKit

class CloudKitHelper {
    var scenarios: [Scenario] = []
    var assets: [ContentAsset] = []
    
    let db = CKContainer.default().publicCloudDatabase
    
    init(){
        fetchScenarioData()
    }
    
    func fetchScenarioData(){
        let assetQuery = CKRecord(recordType: "Asset")
        let scenarioQuery = CKRecord(recordType: "Scenario")
        let reference = CKRecord.Reference(recordID: scenarioQuery.recordID, action: .deleteSelf)
        assetQuery["scenario"] = reference as CKRecordValue
        
        let step = "cover"
        let assetPredicate = NSPredicate(format: "step == %@", step)
        
        let queryAsset = CKQuery(recordType: "Asset", predicate: assetPredicate)
        queryAsset.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        let queryOperationAsset = CKQueryOperation(query: queryAsset)
        
        //Fetching Asset
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
                
                if let reference = record.value(forKey: "scenario") as? CKRecord.Reference {
                    let predicate = NSPredicate(format: "recordID == %@", reference)
                    let query = CKQuery(recordType: "Scenario", predicate: predicate)
                    let queryOperationScenario = CKQueryOperation(query: query)
                    queryOperationScenario.desiredKeys = ["title", "isCompleted", "sentence", "level"]
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
                    
                    self.db.add(queryOperationScenario)
                }
                
            case .failure(let error):
                print("Error recordMatchedBlock: \(error)")
            }
        }
        self.db.add(queryOperationAsset)
    }
}
