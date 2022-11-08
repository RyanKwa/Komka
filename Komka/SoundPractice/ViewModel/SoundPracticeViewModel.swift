//
//  SoundPracticeViewModel.swift
//  Komka
//
//  Created by Minawati on 08/11/22.
//

import UIKit
import CloudKit
import RxSwift

class SoundPracticeViewModel {
    private let scenarioDAO: ScenarioDAO = ScenarioDAO()
    private var scenarioRecordId: CKRecord.ID
    
    private let multipleChoiceVM: MultipleChoiceViewModel?
    private var assets: [ContentAsset] = []
    private var soundPracticeAssets: [ContentAsset] = []
    private var words: [String] = []
    
    var publishScenario = PublishSubject<Scenario>()
    var publishSoundPracticeAssets = PublishSubject<[ContentAsset]>()
    let disposeBag = DisposeBag()
    
    init(scenarioRecordId: CKRecord.ID) {
        self.scenarioRecordId = scenarioRecordId
        multipleChoiceVM = MultipleChoiceViewModel(scenarioRecordId: scenarioRecordId)
    }
    
    func getScenario() {
        scenarioDAO.fetchScenarioByID(scenarioRecordId: scenarioRecordId) { [weak self] fetchedScenario, error in
            if let error = error {
                print(error)
                return
            }
            else if let fetchedScenario = fetchedScenario {
                self?.words = fetchedScenario.sentence
                self?.publishScenario.onNext(fetchedScenario)
                self?.publishScenario.onCompleted()
            }
        }
    }
    
    func getSoundPracticeAssets(){
        multipleChoiceVM?.publishAssets.subscribe(onNext: { publishAssets in
            self.assets = publishAssets
            self.filterSoundPracticeAssets()
        })
        .disposed(by: disposeBag)
    }
    
    private func filterSoundPracticeAssets() {
        for asset in assets {
            if asset.step == AssetStepType.SoundPractice.rawValue || asset.step == AssetStepType.Cover.rawValue {
                soundPracticeAssets.append(asset)
            }
        }
        
        self.publishSoundPracticeAssets.onNext(self.soundPracticeAssets)
        self.publishSoundPracticeAssets.onCompleted()
    }
    
    func getSoundPracticeWord(wordCounter: Int) -> String {
        let word = words[wordCounter-1]
        return word
    }
    
    func getSoundPracticeAssetPart(wordText: String, soundPracticePart: AssetPart) -> CKAsset? {
        var filteredAsset: [ContentAsset]
        
        if wordText == AssetStepType.Cover.rawValue {
            filteredAsset = soundPracticeAssets.filter { $0.part == soundPracticePart.rawValue }
        } else {
            filteredAsset = soundPracticeAssets.filter { $0.part == soundPracticePart.rawValue && $0.title.lowercased() == wordText.lowercased() }
        }
         
        let image: CKAsset? = filteredAsset.first?.image
        
        return image
    }
    
    func playTextToSpeech(wordCounter: Int){
        let word = words[wordCounter-1]
        let queue: [String] = [word]

        TextToSpeechService.shared.stopSpeech()
        TextToSpeechService.shared.startSpeech(queue)
    }
}
