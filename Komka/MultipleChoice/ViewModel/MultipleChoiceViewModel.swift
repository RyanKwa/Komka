//
//  MultipleChoiceViewModel.swift
//  Komka
//
//  Created by Minawati on 19/10/22.
//

import Foundation
import CloudKit
import UIKit
import RxSwift

class MultipleChoiceViewModel {
    private let contentAssetDAO: ContentAssetDAO = ContentAssetDAO()
    private let multipleChoiceDAO: MultipleChoiceDAO = MultipleChoiceDAO()
    
    private var scenarioRecordId: CKRecord.ID
    private let userGender: String
    
    private var assets: [ContentAsset] = []
    private var multipleChoice: MultipleChoice?
    private var multipleChoiceAssets: [ContentAsset] = []
    private var leftChoiceText, rightChoiceText, correctAnswer: String?
    
    var publishMultipleChoiceAssets = PublishSubject<[ContentAsset]>()
    let disposeBag = DisposeBag()
    
    init(scenarioRecordId: CKRecord.ID){
        self.scenarioRecordId = scenarioRecordId
        self.userGender = NSUbiquitousKeyValueStore.default.hasChooseGender
        
        contentAssetDAO.fetchScenarioCoverAsset(scenarioRecordId: scenarioRecordId)
        contentAssetDAO.fetchAllScenarioAssets(scenarioRecordId: scenarioRecordId, userGender: userGender)
        multipleChoiceDAO.fetchMultipleChoiceData(scenarioRecordId: scenarioRecordId) { [weak self] multipleChoice, error in
            // logic error
        }
        
        subscription()
    }
    
    private func subscription() {
        contentAssetDAO.publishAssets.subscribe(onNext: { publishAssets in
            self.assets = publishAssets
            self.filterMultipleChoiceAssets()
        })
        .disposed(by: disposeBag)
    
        multipleChoiceDAO.publishMultipleChoice.subscribe(onNext: { publishMultipleChoice in
            self.multipleChoice = publishMultipleChoice
            self.leftChoiceText = publishMultipleChoice.choices[0]
            self.rightChoiceText = publishMultipleChoice.choices[1]
            self.correctAnswer = publishMultipleChoice.answer
        })
        .disposed(by: disposeBag)
    }
    
    private func filterMultipleChoiceAssets() {
        for asset in assets {
            if asset.step == AssetStepType.MultipleChoice.rawValue || asset.step == AssetStepType.Cover.rawValue {
                multipleChoiceAssets.append(asset)
            }
        }
        
        self.publishMultipleChoiceAssets.onNext(self.multipleChoiceAssets)
        self.publishMultipleChoiceAssets.onCompleted()
    }
    
    func getMultipleChoiceAssetPart(_ multipleChoicePart: MultipleChoicePart) -> UIImage? {
        var asset = UIImage()
        
        for multipleChoiceAsset in multipleChoiceAssets {
            let part = multipleChoiceAsset.part

            if part == multipleChoicePart.rawValue {
                let image = multipleChoiceAsset.image
                
                asset = UIImage.changeImageFromURL(baseImage: image ?? nil)
                
                return asset
            }
        }
        
        return asset
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
