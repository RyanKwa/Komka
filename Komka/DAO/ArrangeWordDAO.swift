//
//  ArrangeWordDAO.swift
//  Komka
//
//  Created by Ryan Vieri Kwa on 25/10/22.
//

import CloudKit
import Foundation

class ArrangeWordDAO {
    
    static let instance = ArrangeWordDAO()
    let publicDB = CKContainer.default().publicCloudDatabase
    
    init(){
        
    }
    func fetchScenarioByID(scenarioID: String, completion: @escaping (Scenario?, FetchError?) -> Void) {
        let recordID = CKRecord.ID(recordName: scenarioID)
        let predicate = NSPredicate(format: "recordID = %@", recordID)
        let query = CKQuery(recordType: "Scenario", predicate: predicate)
        let queryOperation = CKQueryOperation(query: query)
        var fetchedScenario: Scenario? = nil
        
        queryOperation.recordMatchedBlock = { returnedRecordID, returnedResult in
            switch returnedResult {
            case .success(let record):
                guard let title = record["title"] as? String,
                      let isCompleted = record["isCompleted"] as? Bool,
                      let sentence = record["sentence"] as? String,
                      let level = record["level"] as? CKRecord.Reference,
                      let multipleChoice = record["multipleChoice"] as? CKRecord.Reference
                else {
                    completion(nil, FetchError.missingData(recordType: RecordType.Scenario))
                    return
                }
                fetchedScenario = Scenario(id: record.recordID, title: title, isCompleted: isCompleted, sentence: sentence, level: level, reward: nil, multipleChoice: multipleChoice, wordImitations: [])
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
        publicDB.add(queryOperation)
        
    }
    
    func fetchScenario(completion: @escaping ([Scenario]?, FetchError?) -> Void) {
        let query = CKQuery(recordType: "Scenario", predicate: NSPredicate(value: true))
        let queryOperation = CKQueryOperation(query: query)
        var fetchedScenarios = [Scenario]()
        queryOperation.recordMatchedBlock = {returnedRecord, returnedResult in
            switch returnedResult {
            case .success(let record):
                guard
                    let title = record["title"] as? String,
                    let isCompleted = record["isCompleted"] as? Bool,
                    let sentence = record["sentence"] as? String,
                    let level = record["level"] as? CKRecord.Reference,
                    let multipleChoice = record["multipleChoice"] as? CKRecord.Reference
                else {
                    completion(nil, FetchError.missingData(recordType: RecordType.Scenario))
                    return
                }
                fetchedScenarios.append(Scenario(id: record.recordID, title: title, isCompleted: isCompleted, sentence: sentence, level: level, reward: nil, multipleChoice: multipleChoice, wordImitations: []))
            case .failure (_):
                completion(nil, FetchError.failedQuery(recordType: RecordType.Scenario))
            }
        }
        queryOperation.queryResultBlock = { result in
            switch result {
            case .success(_):
                completion(fetchedScenarios, nil)
            case.failure(_):
                completion(nil, FetchError.failedQuery(recordType: RecordType.Scenario))
            }
        }
        publicDB.add(queryOperation)
    }
}
