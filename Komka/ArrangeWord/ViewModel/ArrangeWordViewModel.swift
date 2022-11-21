//
//  ArrangeWordViewModel.swift
//  Komka
//
//  Created by Ryan Vieri Kwa on 25/10/22.
//

import Foundation
import CloudKit

class ArrangeWordViewModel {
    private let scenarioData = ScenarioData.instance
    private let textToSpeechService = TextToSpeechService()
    
    private var arrangeWordAssets: [ContentAsset] = []
    private var sentence: [String] = []
    
    func getArrangeWordAssets() {
        let assets = scenarioData.getAssetsData() ?? []
        let filteredArrangeWordAssets = assets.filter { $0.step == Asset.Step.ArrangeWord.rawValue || $0.step == Asset.Step.Cover.rawValue }
        arrangeWordAssets = filteredArrangeWordAssets
    }
    
    func getSentencesFromScenario() -> [String] {
        sentence = scenarioData.getScenarioData()?.sentence ?? []
        return sentence
    }
    
    func getArrangeWordAssetPart(_ arrangeWordPart: Asset.Part) -> CKAsset? {
        let filteredAsset = arrangeWordAssets.filter { $0.part == arrangeWordPart.rawValue }
        let image: CKAsset? = filteredAsset.first?.image
        
        return image
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
    
    func playTextToSpeech(){
        let sentence = String.convertArrayToString(array: sentence)
        let queue: [String] = [sentence]
        
        textToSpeechService.stopSpeech()
        textToSpeechService.startSpeech(queue)
    }
    
    func stopTextToSpeech(){
        textToSpeechService.stopSpeech()
    }
}
