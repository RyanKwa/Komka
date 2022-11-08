//
//  FullSentencesViewModel.swift
//  Komka
//
//  Created by Minawati on 08/11/22.
//

import UIKit
import CloudKit
import RxSwift

class FullSentencesViewModel {
    private let scenarioDAO: ScenarioDAO = ScenarioDAO()
    private var scenarioRecordId: CKRecord.ID
    
    private let multipleChoiceVM: MultipleChoiceViewModel?
    private var assets: [ContentAsset] = []
    private var fullSentenceAssets: [ContentAsset] = []
    private var scenario: Scenario?
    
    var publishFullSentenceAssets = PublishSubject<[ContentAsset]>()
    var publishFullSentence = PublishSubject<Scenario>()
    let disposeBag = DisposeBag()
    
    init(scenarioRecordId: CKRecord.ID) {
        self.scenarioRecordId = scenarioRecordId
        multipleChoiceVM = MultipleChoiceViewModel(scenarioRecordId: scenarioRecordId)
    }
    
    func getScenario() {
        scenarioDAO.fetchScenarioByID(scenarioRecordId: scenarioRecordId) { [weak self] fetchedScenario, error in
            if let error = error {
                self?.publishFullSentence.onError(error)
                return
            }
            else if let fetchedScenario = fetchedScenario {
                self?.scenario = fetchedScenario
                self?.publishFullSentence.onNext(fetchedScenario)
                self?.publishFullSentence.onCompleted()
            }
        }
    }
    
    func getFullSentenceAssets(){
        multipleChoiceVM?.publishAssets.subscribe(onNext: { publishAssets in
            self.assets = publishAssets
            self.filterFullSentenceAssets()
        })
        .disposed(by: disposeBag)
    }
    
    private func filterFullSentenceAssets() {
        for asset in assets {
            if asset.step == AssetStepType.FullSentence.rawValue || asset.step == AssetStepType.Cover.rawValue {
                fullSentenceAssets.append(asset)
            }
        }
        
        self.publishFullSentenceAssets.onNext(self.fullSentenceAssets)
        self.publishFullSentenceAssets.onCompleted()
    }
    
    func getFullSentenceAssetPart(_ fullSentencePart: AssetPart) -> CKAsset? {
        let filteredAsset = fullSentenceAssets.filter { $0.part == fullSentencePart.rawValue }
        let image: CKAsset? = filteredAsset.first?.image
        
        return image
    }
    
    func getSentence() -> String {
        let words = scenario?.sentence ?? []
        var sentence = ""
        
        for word in words {
            sentence += word + " "
        }
        
        return sentence
    }
    
    func playTextToSpeech(){
        let queue: [String] = scenario?.sentence ?? []
        
        TextToSpeechService.shared.stopSpeech()
        TextToSpeechService.shared.startSpeech(queue)
    }
}

