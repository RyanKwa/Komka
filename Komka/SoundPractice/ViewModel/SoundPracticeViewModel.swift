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
    
    lazy var queueWordCounter: Int = 1
    private (set) lazy var progressFrom = setProgressFrom()
    private (set) lazy var progressTo = setProgressTo()
    
    var audioStreamManager = AudioStreamManager()
    
    var progressPublisher = BehaviorSubject(value: 0.0)
    var audioPublisher = PublishSubject<Double>()
        
    lazy var result = Double()
    
    func setProgressTo() -> Double{
        lazy var tempVar = 0.1
//        audioPublisher.subscribe(onNext: { [self] confidence in
            result = (tempVar * 35.0)/100.0
            
            if result <= 0.0 {
                result = 0.0
            }
            else if result < 0.15 {
                result = 0.15
            }
//        }).disposed(by: disposeBag)

        progressPublisher.onNext(result)
        return result
    }
    
    func setProgressFrom() -> Double{
        progressPublisher.subscribe(onNext: { [self] result in
            progressFrom = result
            print(progressFrom)
            
        }).disposed(by: disposeBag)
        
        return progressFrom
    }
    
    func startSoundPractice(){
        audioStreamManager.startLiveAudio()
        
        //logic dmn, bakal kirim confidence terus menerus (mgkin bisa via publisher, utk trigger si setProgressTo)?
        var confidence = 0.2
        audioPublisher.onNext(confidence)
    }
    
    func stopSoundPractice(){
        audioStreamManager.stopLiveAudio()
    }
}
