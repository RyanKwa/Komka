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
    var isCompleted = 0
    var nextLevelPointsNeeded = 0
    
    var completionPublisher = PublishSubject<Int>()
    var disposeBag = DisposeBag()
    
    func updateIsCompletedToKeyValueStore() {
        scenario = scenarioData.getScenarioData()
        
        guard let scenario = scenario else { return }
        
        if (NSUbiquitousKeyValueStore.default.completedScenario.isEmpty) {
            NSUbiquitousKeyValueStore.default.completedScenario.append(scenario.id.recordName)
        }
        else {
            for completedscenario in NSUbiquitousKeyValueStore.default.completedScenario {
                if(scenario.id.recordName != completedscenario) {
                    NSUbiquitousKeyValueStore.default.completedScenario.append(scenario.id.recordName)
                }
            }
        }
        
        print("COUNT UBI: \(NSUbiquitousKeyValueStore.default.completedScenario.count)")
    }
    
    func unLockScenario(){
        if NSUbiquitousKeyValueStore.default.completedScenario.count == 0 {
            nextLevelPointsNeeded = 3
        }
        else if NSUbiquitousKeyValueStore.default.completedScenario.count == 3 {
            nextLevelPointsNeeded = 6
        }
        
        completionPublisher.onNext(NSUbiquitousKeyValueStore.default.completedScenario.count)
    }
}
