//
//  ArrangeWordViewModel.swift
//  Komka
//
//  Created by Ryan Vieri Kwa on 25/10/22.
//

import CloudKit
import Foundation
import RxSwift
class ArrangeWordViewModel {
    private let scenarioDAO = ScenarioDAO()
    var scenarios = PublishSubject<[Scenario]>()
    var scenario = PublishSubject<Scenario>()
    var sentences = PublishSubject<[String]>()

    func getSentencesFromScenario(scenarioID: CKRecord.ID){

        scenarioDAO.fetchScenarioByID(scenarioID: scenarioID) { [weak self] scenario, error in
            if let error = error {
                self?.sentences.onError(error)
                return
            }
            else if let scenario = scenario {
                self?.sentences.onNext(scenario.sentence)
                self?.sentences.onCompleted()
            }
        }
    }

    func evaluateWordPlacement(selectedWord: String, placementIndex: Int, sentences: [String]) -> Bool {
        guard placementIndex < sentences.count, placementIndex >= 0 else {
            return false
        }
        if sentences[placementIndex] == selectedWord {
            return true
        }
        return false
    }
}
