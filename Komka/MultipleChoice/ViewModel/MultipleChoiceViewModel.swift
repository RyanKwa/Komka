//
//  MultipleChoiceViewModel.swift
//  Komka
//
//  Created by Minawati on 19/10/22.
//

import Foundation
import CloudKit

class MultipleChoiceViewModel {
    private let scenarioData = ScenarioData.instance

    private var multipleChoice: MultipleChoice?
    private var multipleChoiceAssets: [ContentAsset] = []
    private var leftChoiceText, rightChoiceText, correctAnswer: String?
    
    func getMultipleChoiceAssets() {
        let assets = scenarioData.getAssetsData() ?? []
        let filteredMultipleChoiceAsset = assets.filter { $0.step == AssetStepType.MultipleChoice.rawValue || $0.step == AssetStepType.Cover.rawValue }
        multipleChoiceAssets = filteredMultipleChoiceAsset
    }
    
    func getMultipleChoiceData() {
        multipleChoice = scenarioData.getMultipleChoiceData()
        leftChoiceText = multipleChoice?.choices[0]
        rightChoiceText = multipleChoice?.choices[1]
        correctAnswer = multipleChoice?.answer
    }
    
    func getMultipleChoiceAssetPart(_ multipleChoicePart: AssetPart) -> CKAsset? {
        let filteredAsset = multipleChoiceAssets.filter { $0.part == multipleChoicePart.rawValue }
        let image: CKAsset? = filteredAsset.first?.image
        
        return image
    }
    
    func isCorrectAnswer(choice: Choices) -> Bool {
        if choice == .leftChoice && leftChoiceText == correctAnswer{
            return true
        } else if choice == .rightChoice && rightChoiceText == correctAnswer {
            return true
        }
        
        return false
    }
    
    func playTextToSpeech(){
        let imageCaption = multipleChoice?.imageCaption ?? ""
        let question = multipleChoice?.question ?? ""
        let leftChoice = multipleChoice?.choices[0] ?? ""
        let conjunction = "atau"
        let rightChoice = multipleChoice?.choices[1] ?? "" + "?"
        
        let queue: [String] = [imageCaption, question, leftChoice, conjunction, rightChoice]
        
        TextToSpeechService.shared.stopSpeech()
        TextToSpeechService.shared.startSpeech(queue)
    }
}
