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
    var scenarioPerLevel: [Scenario] = []
    
    var level: String?
    
    var scenariosPublisher = PublishSubject<[Scenario]>()
    var assetsPublisher = PublishSubject<[ContentAsset]>()
    var unlockPublisher = PublishSubject<Int>()
    
    var bag = DisposeBag()

    var completionPageVM = CompletionPageViewModel()
    
    func levelByScenario(level: String){
        let filteredLevel = scenarios.filter { $0.levelScenario == level }
        scenarioPerLevel = filteredLevel
    }

    var isCompleted: Int?

    func fetchScenario(){
        scenarioDAO.fetchScenarioData()
        contentAssetDAO.fetchCoverAssets()
        
        scenarioDAO.scenariosPublisher.subscribe(
            onError: { [weak self] error in
                self?.scenariosPublisher.onError(error)
                print(error.localizedDescription)
            },
            onCompleted: {
            self.scenarios = self.scenarioDAO.scenarios

            self.scenariosPublisher.onNext(self.scenarios)
            self.scenariosPublisher.onCompleted()
        }).disposed(by: bag)
        
        contentAssetDAO.publishAssets.subscribe(
            onError: { [weak self] error in
                self?.scenariosPublisher.onError(error)
                print(error.localizedDescription)
            },
            onCompleted: {
            self.assets = self.contentAssetDAO.assets

            self.assetsPublisher.onNext(self.assets)
            self.assetsPublisher.onCompleted()
        }).disposed(by: bag)
    }
    
    func updateCompletedScenarioValue() -> Int {
        return NSUbiquitousKeyValueStore.default.completedScenario.count
    }
}
