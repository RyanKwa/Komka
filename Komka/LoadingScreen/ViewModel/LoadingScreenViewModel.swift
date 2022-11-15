//
//  LoadingScreenVM.swift
//  Komka
//
//  Created by Ryan Vieri Kwa on 07/11/22.
//

import CloudKit
import Foundation
import RxSwift
class LoadingScreenViewModel {
    private let scenarioDataInstance = ScenarioData.instance
    
    private let scenarioDAO: ScenarioDAO
    private let multipleChoicDAO: MultipleChoiceDAO
    private let contentAssetDAO: ContentAssetDAO
    
    public private(set) var currentProgress: CGFloat
    var totalFetchTask: Int
    
    var isLoading = BehaviorSubject<Bool>(value: true)
    var totalFetchCompleted = BehaviorSubject<Int>(value: 0)
    
    private let disposeBag = DisposeBag()
    init() {
        currentProgress = 0.0
        totalFetchTask = 3
        scenarioDAO = ScenarioDAO()
        multipleChoicDAO = MultipleChoiceDAO()
        contentAssetDAO = ContentAssetDAO()
    }
    func incrementProgress(by incrementValue: CGFloat) {
        do {
            let numberOfFetchCompleted = try CGFloat(totalFetchCompleted.value())
            currentProgress += incrementValue + numberOfFetchCompleted
        }
        catch {
            self.totalFetchCompleted.onError(error)
            print("Value not available")
        }
    }
    
    func fetchRecordScenario(scenarioID: CKRecord.ID) {
        fetchMultipleChoiceRecord(scenarioID: scenarioID)
        fetchScenario(scenarioID: scenarioID)
        fetchAssets(scenarioID: scenarioID)
    }
    
    func finishLoadingProgress () {
        self.isLoading.onNext(false)
        self.isLoading.onCompleted()
        self.totalFetchCompleted.onCompleted()
    }
    
    private func fetchMultipleChoiceRecord(scenarioID: CKRecord.ID) {
        multipleChoicDAO.fetchMultipleChoiceData(scenarioRecordId: scenarioID) { [weak self] multipleChoice, error in
            if let error = error{
                self?.totalFetchCompleted.onError(error)
                print(error.description)
                return
            }
            else if let multipleChoice = multipleChoice {
                do {
                    try self?.totalFetchCompleted.onNext((self?.totalFetchCompleted.value() ?? 0) + 1)
                    self?.scenarioDataInstance.save(multipleChoice: multipleChoice)
                }
                catch {
                    self?.totalFetchCompleted.onError(error)
                    print("Value not available")
                }
            }
        }
    }
    
    /// Fetch a specific scenario from CloudKit
    private func fetchScenario(scenarioID: CKRecord.ID) {
        scenarioDAO.fetchScenarioByID(scenarioRecordId: scenarioID) { [weak self] scenario, error in
            if let error = error {
                self?.totalFetchCompleted.onError(error)
                print(error.description)
                return
            }
            else if let scenario = scenario {
                do {
                    try self?.totalFetchCompleted.onNext((self?.totalFetchCompleted.value() ?? 0) + 1)
                    self?.scenarioDataInstance.save(scenario: scenario)
                }
                catch {
                    self?.totalFetchCompleted.onError(error)
                    print("Value not available")
                }
            }
        }
    }
    
    /// Fetch assets data from CloudKit
    private func fetchAssets(scenarioID: CKRecord.ID) {
        contentAssetDAO.fetchAllScenarioAssets(
            scenarioRecordId: scenarioID,
            userGender: NSUbiquitousKeyValueStore.default.hasChooseGender
        ) { [weak self] assets, error in
            if let error = error {
                self?.totalFetchCompleted.onError(error)
                print(error.description)
                return
            }
            else if let assets = assets {
                do {
                    try self?.totalFetchCompleted.onNext((self?.totalFetchCompleted.value() ?? 0) + 1)
                    self?.scenarioDataInstance.save(assets: assets)
                }
                catch {
                    self?.totalFetchCompleted.onError(error)
                    print("Value not available")
                }
            }
        }
    }
}
