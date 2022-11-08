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
    private let scenarioData = ScenarioData.instance
    
    private var soundPracticeAssets: [ContentAsset] = []
    private(set) var words: [String] = []
    
    func getScenario() {
        words = scenarioData.getScenarioData()?.sentence ?? []
    }
    
    func getSoundPracticeAssets(){
        let assets = scenarioData.getAssetsData() ?? []
        let filteredSoundPracticeAssets = assets.filter { $0.step == AssetStepType.SoundPractice.rawValue || $0.step == AssetStepType.Cover.rawValue }
        soundPracticeAssets = filteredSoundPracticeAssets
    }
    
    func getSoundPracticeWord(wordCounter: Int) -> String {
        if (wordCounter < 1 || wordCounter > words.count) {
            return "ERROR: Index out of range"
        }
        
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
    
    func playTextToSpeech(wordCounter: Int) -> String? {
        if (wordCounter < 1 || wordCounter > words.count) {
            return "ERROR: Index out of range"
        }
        
        let word = words[wordCounter-1]
        let queue: [String] = [word]

        TextToSpeechService.shared.stopSpeech()
        TextToSpeechService.shared.startSpeech(queue)
        
        return ""
    }
    
    lazy var queueWordCounter: Int = 1
    private (set) lazy var progressFrom = setProgressFrom()
    private (set) lazy var progressTo = setProgressTo()
    
    var audioStreamManager = AudioStreamManager()
    
    var progressPublisher = BehaviorSubject(value: 0.0)
    var audioPublisher = PublishSubject<Double>()
        
    lazy var result = Double()
    
    var disposeBag = DisposeBag()
    
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
