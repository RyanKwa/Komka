//
//  ArrangeWordViewModel.swift
//  Komka
//
//  Created by Ryan Vieri Kwa on 25/10/22.
//

import Foundation
import RxSwift
class ArrangeWordViewModel {
    private let scenarioDAO = ScenarioDAO()
    var scenarios = PublishSubject<[Scenario]>()
    var scenario = PublishSubject<Scenario>()
    var sentences = PublishSubject<[String]>()

    func getSentencesFromScenario(scenarioID: String){

        scenarioDAO.fetchScenarioByID(scenarioID: scenarioID) { [weak self] scenario, error in
            if let error = error {
                self?.sentences.onError(error)
                return
            }
            else if let scenario = scenario {
                let sentences = scenario.sentence.split(separator: " ").compactMap({String($0).capitalized})
                self?.sentences.onNext(sentences)
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
