//
//  ChooseScenarioViewModel.swift
//  Komka
//
//  Created by Evelin Evelin on 11/10/22.
//

import Foundation
import CloudKit
import UIKit

class ChooseScenarioViewModel {
    var scenarioDAO = ScenarioDAO.instance
    
    @Published var scenarios: [Scenario] = []
    @Published var assets: [ContentAsset] = []
    
    func fetchScenario(){
        scenarioDAO.fetchScenarioData()
        DispatchQueue.main.asyncAfter(deadline: .now()+2){
            self.scenarios = self.scenarioDAO.scenarios
            self.assets = self.scenarioDAO.assets
        }
    }
}
