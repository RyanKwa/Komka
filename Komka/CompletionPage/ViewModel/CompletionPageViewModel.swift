//
//  CompletionPageViewModel.swift
//  Komka
//
//  Created by Evelin Evelin on 14/11/22.
//

import Foundation
import RxSwift

class CompletionPageViewModel {
    private let scenarioData = ScenarioData.instance
    private(set) var scenario: Scenario?
    
    private var scenarioTemp: [Scenario] = []
    
    var isCompleted = NSUbiquitousKeyValueStore.default.completedScenario.count
    
    var completionPublisher = PublishSubject<Int>()
    var disposeBag = DisposeBag()
    
    func updateIsCompletedToKeyValueStore() {
        scenario = scenarioData.getScenarioData()
        
        guard let scenario = scenario else { return }
        
        if (NSUbiquitousKeyValueStore.default.completedScenario.isEmpty) {
            NSUbiquitousKeyValueStore.default.completedScenario.append(scenario.id.recordName)
        }
        else {
            if (!NSUbiquitousKeyValueStore.default.completedScenario.contains(scenario.id.recordName)) {
                NSUbiquitousKeyValueStore.default.completedScenario.append(scenario.id.recordName)
            }
        }
        
        completionPublisher.onNext(NSUbiquitousKeyValueStore.default.completedScenario.count)
    }
}
