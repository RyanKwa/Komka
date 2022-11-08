//
//  MultipleChoiceViewModel.swift
//  Komka
//
//  Created by Minawati on 19/10/22.
//

import Foundation
import CloudKit
import RxSwift

class MultipleChoiceViewModel {
    private let contentAssetDAO: ContentAssetDAO = ContentAssetDAO()
    private let multipleChoiceDAO: MultipleChoiceDAO = MultipleChoiceDAO()
    
    private var scenarioRecordId: CKRecord.ID
    private let userGender: String
    
    private var assets: [ContentAsset] = []
    private var coverAssets: [ContentAsset] = []
    private var multipleChoice: MultipleChoice?
    private var multipleChoiceAssets: [ContentAsset] = []
    private var leftChoiceText, rightChoiceText, correctAnswer: String?
    
    var publishAssets = PublishSubject<[ContentAsset]>()
    var publishMultipleChoiceAssets = PublishSubject<[ContentAsset]>()
    let disposeBag = DisposeBag()
    
    init(scenarioRecordId: CKRecord.ID){
        self.scenarioRecordId = scenarioRecordId
        self.userGender = NSUbiquitousKeyValueStore.default.hasChooseGender
        getScenarioCoverAsset()
        getScenarioAssets()
        getMultipleChoiceData()
    }
    
    func getScenarioCoverAsset() {
        contentAssetDAO.fetchCoverAssets()
        
        contentAssetDAO.publishAssets.subscribe(onNext: { coverAssets in
            self.coverAssets = coverAssets
            self.filterScenarioCoverAssetById(scenarioRecordId: self.scenarioRecordId)
        })
        .disposed(by: disposeBag)
    }
    
    func getScenarioAssets() {
        contentAssetDAO.fetchAllScenarioAssets(scenarioRecordId: scenarioRecordId, userGender: userGender) { [weak self] assets, error in
            if let error = error {
                self?.publishMultipleChoiceAssets.onError(error)
                return
            }
            else if let assets = assets {
                self?.assets.append(contentsOf: assets)
                self?.publishAssets.onNext(assets)
                self?.publishAssets.onCompleted()
                self?.filterMultipleChoiceAssets()
            }
        }
    }
    
    func getMultipleChoiceData() {
        multipleChoiceDAO.fetchMultipleChoiceData(scenarioRecordId: scenarioRecordId) { [weak self] multipleChoice, error in
            if let error = error {
                print(error)
                return
            }
            else if let multipleChoice = multipleChoice {
                self?.multipleChoice = multipleChoice
                self?.leftChoiceText = multipleChoice.choices[0]
                self?.rightChoiceText = multipleChoice.choices[1]
                self?.correctAnswer = multipleChoice.answer
            }
        }
    }
    
    private func filterScenarioCoverAssetById(scenarioRecordId: CKRecord.ID) {
        for coverAsset in coverAssets {
            if coverAsset.scenario.recordID == scenarioRecordId && coverAsset.step == AssetStepType.Cover.rawValue {
                multipleChoiceAssets.append(coverAsset)
            }
        }
    }
    
    private func filterMultipleChoiceAssets() {
        for asset in assets {
            if asset.step == AssetStepType.MultipleChoice.rawValue {
                multipleChoiceAssets.append(asset)
            }
        }
        
        self.publishMultipleChoiceAssets.onNext(self.multipleChoiceAssets)
        self.publishMultipleChoiceAssets.onCompleted()
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
