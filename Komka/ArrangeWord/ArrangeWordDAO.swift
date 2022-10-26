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
    func fetchScenarioByID(scenarioID: String, completion: @escaping (Scenario) -> Void) {
        let recordID = CKRecord.ID(recordName: scenarioID)
        let predicate = NSPredicate(format: "recordID = %@", recordID)
        let query = CKQuery(recordType: "Scenario", predicate: predicate)
        let queryOperation = CKQueryOperation(query: query)
        var fetchedScenario: Scenario? = nil
        
        queryOperation.recordMatchedBlock = { returnedRecord, returnedResult in
            switch returnedResult {
            case .success(let record):
                guard let title = record["title"] as? String else {
                    return
                }
                if let isCompleted = record["isCompleted"] as? Bool, let sentence = record["sentence"] as? String, let level = record["level"] as? CKRecord.Reference {
                    fetchedScenario = Scenario(id: record.recordID, title: title, isCompleted: isCompleted, sentence: sentence, level: level, reward: nil, multipleChoice: nil, wordImitations: [])
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        queryOperation.queryResultBlock = { result in
            let recordID = CKRecord.ID(recordName: "Scenario")
            let dummyScenario = Scenario(id: recordID, title: "Dummy", isCompleted: false, sentence: "Dummy sentence", level: CKRecord.Reference(recordID: recordID, action: .deleteSelf), reward: nil, multipleChoice: nil, wordImitations: [])
            completion(fetchedScenario ?? dummyScenario)
        }
        publicDB.add(queryOperation)

    }
    
    func fetchScenario(completion: @escaping ([Scenario]) -> Void) {
        let query = CKQuery(recordType: "Scenario", predicate: NSPredicate(value: true))
        let queryOperation = CKQueryOperation(query: query)
        var fetchedScenarios = [Scenario]()
        queryOperation.recordMatchedBlock = {returnedRecord, returnedResult in
            switch returnedResult {
            case .success(let record):
                guard let title = record["title"] as? String else {
                    return
                }
                if let isCompleted = record["isCompleted"] as? Bool, let sentence = record["sentence"] as? String, let level = record["level"] as? CKRecord.Reference {
                    fetchedScenarios.append(Scenario(id: record.recordID, title: title, isCompleted: isCompleted, sentence: sentence, level: level, reward: nil, multipleChoice: nil, wordImitations: []))
                }
            case .failure (let error):
                print(error.localizedDescription)
                
            }
        }
        queryOperation.queryResultBlock = { result in
            completion(fetchedScenarios)
        }
        publicDB.add(queryOperation)
    }
}
