//
//  SoundPracticeViewModel.swift
//  Komka
//
//  Created by Minawati on 08/11/22.
//

import UIKit
import CloudKit

class SoundPracticeViewModel {
    private let scenarioData = ScenarioData.instance
    private let textToSpeechService = TextToSpeechService()
    
    private var soundPracticeAssets: [ContentAsset] = []
    private var words: [String] = []
    
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

        textToSpeechService.stopSpeech()
        textToSpeechService.startSpeech(queue)
        
        return ""
    }
    
    func stopTextToSpeech(){
        textToSpeechService.stopSpeech()
    }
}
