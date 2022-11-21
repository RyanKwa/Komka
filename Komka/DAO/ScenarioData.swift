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
        var scenarioData: Scenario?
        var words: [String] = []
        let gender = NSUbiquitousKeyValueStore.default.hasChooseGender

        if fetchedScenario.title == "Kamar Tidur" && fetchedScenario.levelScenario == LevelScenario.sedang.rawValue {
            if gender == "Male" {
                words = ["Saya", "Gambar", "Mobil"]
            } else if gender == "Female" {
                words = ["Saya", "Gambar", "Bunga"]
            }
            
            scenarioData = Scenario(id: fetchedScenario.id, title: fetchedScenario.title, isCompleted: fetchedScenario.isCompleted, sentence: words, reward: fetchedScenario.reward, multipleChoice: fetchedScenario.multipleChoice, levelScenario: fetchedScenario.levelScenario)
            self.scenario = scenarioData
            
        } else {
            self.scenario = fetchedScenario
        }
    }

    func save(assets fetchedAssets: [ContentAsset]){
        self.assetsData = fetchedAssets
    }
    
    func save(multipleChoice fetchedMultipleChoice: MultipleChoice){
        self.multipleChoiceData = fetchedMultipleChoice
    }
    
}
