//
//  Database.swift
//  Komka
//
//  Created by Ryan Vieri Kwa on 08/11/22.
//

import Foundation

class ScenarioData {
    static let instance = ScenarioData()

    private var scenario: Scenario?
    private var assetsData: [ContentAsset]?
    private var multipleChoiceData: MultipleChoice?
    
    init () {
        
    }
    //MARK: Get
    func getMultipleChoiceData() -> MultipleChoice? {
        return multipleChoiceData
    }
    
    func getScenarioData() -> Scenario? {
        return scenario
    }
    
    func getAssetsData() -> [ContentAsset]? {
        return assetsData
    }
    
    //MARK: Set
    func save(scenario fetchedScenario: Scenario){
        self.scenario = fetchedScenario
    }

    func save(assets fetchedAssets: [ContentAsset]){
        self.assetsData = fetchedAssets
    }
    
    func save(multipleChoice fetchedMultipleChoice: MultipleChoice){
        self.multipleChoiceData = fetchedMultipleChoice
    }
    
}
