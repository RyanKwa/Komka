//
//  ChooseScenarioViewModel.swift
//  Komka
//
//  Created by Evelin Evelin on 11/10/22.
//

import Foundation
import CloudKit
import UIKit
import RxSwift

class ChooseScenarioViewModel {
    var scenarioDAO = ScenarioDAO()

    var scenarios: [Scenario] = []
    var assets: [ContentAsset] = []
        
    var scenariosPublisher = PublishSubject<[Scenario]>()
    var assetsPublisher = PublishSubject<[ContentAsset]>()
    
    var bag = DisposeBag()

    
    func fetchScenario(){
        scenarioDAO.fetchScenarioData()
        scenarioDAO.fetchAssetData()

        scenarioDAO.assetsPublisher.subscribe(onCompleted: {
            self.assets = self.scenarioDAO.assets
            self.scenarios = self.scenarioDAO.scenarios

            self.assetsPublisher.onNext(self.assets)
            self.assetsPublisher.onCompleted()
        }).disposed(by: bag)
        
    }
}
