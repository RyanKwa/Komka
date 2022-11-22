//
//  SoundPracticeViewModel.swift
//  Komka
//
//  Created by Minawati on 08/11/22.
//

import AVFoundation
import UIKit
import CloudKit
import RxSwift

class SoundPracticeViewModel {
    private let scenarioData = ScenarioData.instance
    private let textToSpeechService = TextToSpeechService()
    
    private var soundPracticeAssets: [ContentAsset] = []
    private(set) var words: [String] = []
    
    lazy var queueWordCounter: Int = 1
    lazy var currentProgress = 0.0
    lazy var progressTo = 0.0
    lazy var duration: TimeInterval = 0.25
    
    var audioStreamManager = AudioStreamManager()
    var soundAnalyzer = SoundAnalyzer()

    var confidenceResultPublisher = PublishSubject<Double>()
    var progressPublisher = BehaviorSubject(value: 0.0)
    var confidencePublisher = PublishSubject<Double>()
    let disposeBag = DisposeBag()

    lazy var confidenceResult = Double()
    
    static var willPop = true
    var isFirstWord = true
    var isLastWord = false
        
    func getScenario() {
        words = scenarioData.getScenarioData()?.sentence ?? []
    }
    
    func setSoundAnalyzer(){
        soundAnalyzer.currentWord = words[queueWordCounter-1]
    }
    
    func getSoundPracticeAssets(){
        let assets = scenarioData.getAssetsData() ?? []
        let filteredSoundPracticeAssets = assets.filter { $0.step == Asset.Step.SoundPractice.rawValue || $0.step == Asset.Step.Cover.rawValue }
        soundPracticeAssets = filteredSoundPracticeAssets
    }
    
    func getSoundPracticeWord(wordCounter: Int) -> String {
        if (wordCounter < 1 || wordCounter > words.count) {
            return "Words Not Found"
        }
        
        let word = words[wordCounter-1]
        return word
    }
    
    func getSoundPracticeAssetPart(wordText: String, soundPracticePart: Asset.Part) -> CKAsset? {
        var filteredAsset: [ContentAsset]
        
        if wordText == Asset.Step.Cover.rawValue {
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
        
        textToSpeechService.stopSpeech()
        textToSpeechService.startSpeech(queue)
        
        return ""
    }
    
    func calculateProgress(){
        confidencePublisher.subscribe(onNext: { [self] confidence in
            confidenceResult = (confidence * 35.0)/100.0
            
            if confidenceResult <= 0.0 {
                confidenceResult = 0.0
            }
            else if confidenceResult < 0.15 {
                confidenceResult = 0.05
            }
            else {
                confidenceResult = 0.15
            }
            
            confidenceResultPublisher.onNext(confidenceResult)
        }).disposed(by: disposeBag)
    }
    
    func setProgress(_ progress: Double){
        if (progressTo < 1.0){
            progressTo += progress
            
            progressPublisher.onNext(progressTo)
        }
        if (progressTo >= 1.0){
            progressPublisher.onCompleted()
        }
        
        progressPublisher.subscribe { [self] progressResult in
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [self] in
                currentProgress = progressResult
            }
        }.disposed(by: disposeBag)
    }

    func startSoundPractice(){
        audioStreamManager.startLiveRecord()
        audioStreamManager.addResultObservation(with: soundAnalyzer)
        
        soundAnalyzer.confidencePublisher.subscribe { [self] confidence in
            confidencePublisher.onNext(confidence)
        }.disposed(by: disposeBag)
    }
    
    func stopSoundPractice(){
        audioStreamManager.stopLiveRecord()
    }
    
    func stopTextToSpeech(){
        textToSpeechService.stopSpeech()
    }
}
