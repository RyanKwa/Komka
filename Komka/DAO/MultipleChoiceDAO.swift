//
//  MultipleChoiceDAO.swift
//  Komka
//
//  Created by Minawati on 24/10/22.
//

import Foundation
import CloudKit
import RxSwift

class MultipleChoiceDAO {    
    private let ckHelper: CKHelper
    private var scenario: Scenario?
    private var multipleChoice: MultipleChoice?
    
    init() {
        self.ckHelper = CKHelper.shared
    }
    
    func fetchMultipleChoiceData(scenarioRecordId: CKRecord.ID, completion: @escaping (MultipleChoice?, FetchError?) -> Void){
        let scenarioRecord = CKRecord(recordType: RecordType.Scenario.rawValue)
        let multipleChoiceRecord = CKRecord(recordType: RecordType.MultipleChoice.rawValue)
        let reference = CKRecord.Reference(recordID: multipleChoiceRecord.recordID, action: .deleteSelf)
        scenarioRecord["multipleChoice"] = reference as CKRecordValue
        
        let scenarioPredicate = NSPredicate(format: "recordID == %@", scenarioRecordId)
        let queryScenario = CKQuery(recordType: RecordType.Scenario.rawValue, predicate: scenarioPredicate)
        let queryOperationScenario = CKQueryOperation(query: queryScenario)
        queryOperationScenario.qualityOfService = .userInitiated
//        queryOperationScenario.desiredKeys = ["title", "isCompleted", "sentence", "level", "multipleChoice"]
        queryOperationScenario.recordMatchedBlock = { (returnedRecordID, returnedScenario) in
            switch returnedScenario {
            case .success(let record):
                guard
                    let scenarioTitle = record["title"] as? String,
                    let scenarioStatus = record["isCompleted"] as? Bool,
                    let scenarioSentence = record["sentence"] as? [String],
//                    let scenarioLevel = record["level"] as? CKRecord.Reference,
                    let multipleChoice = record["multipleChoice"] as? CKRecord.Reference,
                    let levelScenario = record["levelScenario"] as? String
                else {
                    completion(nil, FetchError.missingData(recordType: RecordType.Scenario))
                    return
                }
                
                self.scenario = Scenario(id: returnedRecordID, title: scenarioTitle, isCompleted: scenarioStatus, sentence: scenarioSentence, reward: nil, multipleChoice: multipleChoice, levelScenario: levelScenario)
                
                if let reference = record.value(forKey: "multipleChoice") as? CKRecord.Reference {
                    let predicate = NSPredicate(format: "recordID == %@", reference)
                    let multipleChoiceQuery = CKQuery(recordType: RecordType.MultipleChoice.rawValue, predicate: predicate)
                    let queryOperationMultipleChoice = CKQueryOperation(query: multipleChoiceQuery)
                    
                    queryOperationMultipleChoice.desiredKeys = ["imageCaption", "question", "choices", "answer"]
                    queryOperationMultipleChoice.recordMatchedBlock = { (returnedRecordID, returnedMultipleChoice) in
                        switch returnedMultipleChoice {
                        case .success(let record):
                            guard
                                let multipleChoiceImageCaption = record["imageCaption"] as? String,
                                let multipleChoiceQuestion = record["question"] as? String,
                                let multipleChoiceChoices = record["choices"] as? [String],
                                let multipleChoiceAnswer = record["answer"] as? String
                            else {
                                completion(nil, FetchError.missingData(recordType: RecordType.MultipleChoice))
                                return
                            }
                            
                            self.multipleChoice = MultipleChoice(id: returnedRecordID, imageCaption: multipleChoiceImageCaption, question: multipleChoiceQuestion, choices: multipleChoiceChoices, answer: multipleChoiceAnswer)
                            
                        case .failure(_):
                            completion(nil, FetchError.failedQuery(recordType: RecordType.MultipleChoice))
                        }
                    }
                    
                    queryOperationMultipleChoice.queryResultBlock = { result in
                        switch result {
                        case .success(_):
                            completion(self.multipleChoice, nil)
                        case.failure(_):
                            completion(nil, FetchError.failedQuery(recordType: RecordType.MultipleChoice))
                        }
                    }
                    
                    self.ckHelper.publicDB.add(queryOperationMultipleChoice)
                }
                
            case .failure(_):
                completion(nil, FetchError.failedQuery(recordType: RecordType.Scenario))
            }
        }
        
        ckHelper.publicDB.add(queryOperationScenario)
    }
}
