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
    var ckHelper = CloudKitHelper()
    
    @Published var scenarios: [Scenario] = []
    @Published var assets: [Asset] = []
    
    init(){
        DispatchQueue.main.asyncAfter(deadline: .now()+2){
            self.scenarios = self.ckHelper.scenarios
            self.assets = self.ckHelper.assets
        }
    }
}
