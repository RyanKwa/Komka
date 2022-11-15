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
    var ckHelper = CKHelper.shared
    var scenarios: [Scenario] = []
    
    var scenariosPublisher = PublishSubject<[Scenario]>()

    func fetchScenarioByID(scenarioRecordId: CKRecord.ID, completion: @escaping (Scenario?, FetchError?) -> Void) {
        let predicate = NSPredicate(format: "recordID = %@", scenarioRecordId)
        let query = CKQuery(recordType: RecordType.Scenario.rawValue, predicate: predicate)
        let queryOperation = CKQueryOperation(query: query)
        var fetchedScenario: Scenario? = nil
        
        queryOperation.recordMatchedBlock = { returnedRecordID, returnedResult in
            switch returnedResult {
            case .success(let record):
                guard let title = record["title"] as? String,
                      let isCompleted = record["isCompleted"] as? Bool,
                      let sentence = record["sentence"] as? [String],
                      let level = record["level"] as? CKRecord.Reference,
                      let multipleChoice = record["multipleChoice"] as? CKRecord.Reference
                else {
                    completion(nil, FetchError.missingData(recordType: RecordType.Scenario))
                    return
                }
                
                fetchedScenario = Scenario(id: record.recordID, title: title, isCompleted: isCompleted, sentence: sentence, level: level, reward: nil, multipleChoice: multipleChoice)
                
            case .failure(_):
                completion(nil, FetchError.failedQuery(recordType: RecordType.Scenario))
            }
        }
        
        queryOperation.queryResultBlock = { result in
            switch result {
            case .success(_):
                completion(fetchedScenario, nil)
            case.failure(_):
                completion(nil, FetchError.failedQuery(recordType: RecordType.Scenario))
            }
        }
        
        self.ckHelper.publicDB.add(queryOperation)
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
                    let scenarioSentence = record["sentence"] as? [String],
                    let scenarioLevel = record["level"] as? CKRecord.Reference,
                    let multipleChoice = record["multipleChoice"] as? CKRecord.Reference
                else {
                    self.scenariosPublisher.onError(FetchError.missingData(recordType: RecordType.Scenario))
                    return
                }
                
                self.scenarios.append(Scenario(id: returnedRecordID, title: scenarioTitle, isCompleted: scenarioStatus, sentence: scenarioSentence, level: scenarioLevel, reward: nil, multipleChoice: multipleChoice))
                
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
        self.ckHelper.publicDB.add(queryOperationScenario)
        
    }
    
}
