//
//  ArrangeWordViewModel.swift
//  Komka
//
//  Created by Ryan Vieri Kwa on 25/10/22.
//

import Foundation
import RxSwift
class ArrangeWordViewModel {
    private let arrangeWordDAO = ArrangeWordDAO.instance
    var scenarios = PublishSubject<[Scenario]>()
    var scenario = PublishSubject<Scenario>()
    var sentences = PublishSubject<[String]>()
    init() {
        fetchAllScenario()
    }
    func fetchAllScenario() {
        arrangeWordDAO.fetchScenario { [weak self] fetchedScenarios, error  in
            if let error = error {
                self?.scenarios.onError(error)
                return
            }
            else if let fetchedScenarios = fetchedScenarios {
                self?.scenarios.onNext(fetchedScenarios)
                self?.scenarios.onCompleted()
            }
        }
    }
    func getSentencesFromScenario(scenarioID: String){

        arrangeWordDAO.fetchScenarioByID(scenarioID: scenarioID) { [weak self] scenario, error in
            if let error = error {
                self?.sentences.onError(error)
                return
            }
            else if let scenario = scenario {
                let sentences = scenario.sentence.split(separator: " ").compactMap({String($0)})
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
