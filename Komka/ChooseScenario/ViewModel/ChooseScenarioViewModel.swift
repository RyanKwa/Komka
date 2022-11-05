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
    private let scenarioDAO = ScenarioDAO()
    private let contentAssetDAO = ContentAssetDAO()

    var scenarios: [Scenario] = []
    var assets: [ContentAsset] = []
        
    var scenariosPublisher = PublishSubject<[Scenario]>()
    var assetsPublisher = PublishSubject<[ContentAsset]>()
    
    var bag = DisposeBag()

    
    func fetchScenario(){
        scenarioDAO.fetchScenarioData()
        contentAssetDAO.fetchCoverAsset()
        
        scenarioDAO.scenariosPublisher.subscribe(onCompleted: {
            self.scenarios = self.scenarioDAO.scenarios

            self.scenariosPublisher.onNext(self.scenarios)
            self.scenariosPublisher.onCompleted()
        }).disposed(by: bag)
        
        contentAssetDAO.publishAssets.subscribe(onCompleted: {
            self.assets = self.scenarioDAO.assets

            self.assetsPublisher.onNext(self.assets)
            self.assetsPublisher.onCompleted()
        }).disposed(by: bag)
    }
}
