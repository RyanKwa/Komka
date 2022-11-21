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
    private let scenarioData = ScenarioData.instance
    private let textToSpeechService = TextToSpeechService()
    
    private var fullSentenceAssets: [ContentAsset] = []
    private var scenario: Scenario?
    private var words: [String] = []
    
    func getScenarioSentence() {
        scenario = scenarioData.getScenarioData()
        words = scenario?.sentence ?? []
    }
    
    func getFullSentenceAssets(){
        let assets = scenarioData.getAssetsData() ?? []
        let filteredFullSentenceAssets = assets.filter { $0.step == Asset.Step.FullSentence.rawValue || $0.step == Asset.Step.Cover.rawValue }
        fullSentenceAssets = filteredFullSentenceAssets
    }
    
    func getFullSentenceAssetPart(_ fullSentencePart: Asset.Part) -> CKAsset? {
        let filteredAsset = fullSentenceAssets.filter { $0.part == fullSentencePart.rawValue }
        let image: CKAsset? = filteredAsset.first?.image
        
        return image
    }
    
    func getSentence() -> String {
        return String.convertArrayToString(array: words)
    }
    
    func playTextToSpeech(){
        let sentence = getSentence()
        let queue: [String] = [sentence]
        
        textToSpeechService.stopSpeech()
        textToSpeechService.startSpeech(queue)
    }
    
    func stopTextToSpeech(){
        textToSpeechService.stopSpeech()
    }
}

