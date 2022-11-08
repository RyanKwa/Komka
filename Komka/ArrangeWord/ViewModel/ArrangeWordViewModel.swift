//
//  ArrangeWordViewModel.swift
//  Komka
//
//  Created by Ryan Vieri Kwa on 25/10/22.
//

import CloudKit
import Foundation
import CloudKit
import RxSwift

class ArrangeWordViewModel {
    private let scenarioDAO = ScenarioDAO()
    private var scenarioRecordId: CKRecord.ID
    
    private let multipleChoiceVM: MultipleChoiceViewModel?
    private var assets: [ContentAsset] = []
    private var arrangeWordAssets: [ContentAsset] = []
    
    var scenarios = PublishSubject<[Scenario]>()
    var scenario = PublishSubject<Scenario>()
    var sentences = PublishSubject<[String]>()
    var publishArrangeWordAssets = PublishSubject<[ContentAsset]>()
    let disposeBag = DisposeBag()

    init(scenarioRecordId: CKRecord.ID) {
        self.scenarioRecordId = scenarioRecordId
        multipleChoiceVM = MultipleChoiceViewModel(scenarioRecordId: scenarioRecordId)
    }
    
    func getAllAsset() {
        multipleChoiceVM?.publishAssets.subscribe(onNext: { publishAssets in
            self.assets = publishAssets
            self.filterArrangeWordAssets()
        })
        .disposed(by: disposeBag)
    }
    
    private func filterArrangeWordAssets() {
        for asset in assets {
            if asset.step == AssetStepType.ArrangeWord.rawValue || asset.step == AssetStepType.Cover.rawValue {
                arrangeWordAssets.append(asset)
            }
        }
        
        self.publishArrangeWordAssets.onNext(self.arrangeWordAssets)
        self.publishArrangeWordAssets.onCompleted()
    }
    
    func getArrangeWordAssetPart(_ arrangeWordPart: AssetPart) -> CKAsset? {
        let filteredAsset = arrangeWordAssets.filter { $0.part == arrangeWordPart.rawValue }
        let image: CKAsset? = filteredAsset.first?.image
        
        return image
    }
    
    func getSentencesFromScenario(scenarioRecordId: CKRecord.ID){
        scenarioDAO.fetchScenarioByID(scenarioRecordId: scenarioRecordId) { [weak self] scenario, error in
            if let error = error {
                self?.sentences.onError(error)
                return
            }
            else if let scenario = scenario {
                self?.sentences.onNext(scenario.sentence)
                self?.sentences.onCompleted()
            }
        }
    }

    func evaluateWordPlacement(selectedWord: String, placementIndex: Int, sentences: [String]) -> Bool {
        guard placementIndex < sentences.count, placementIndex >= 0 else {
            return false
        }
        if sentences[placementIndex] == selectedWord {
            return true
        }
        return false
    }
}
