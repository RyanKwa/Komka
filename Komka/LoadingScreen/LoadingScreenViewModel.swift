//
//  LoadingScreenVM.swift
//  Komka
//
//  Created by Ryan Vieri Kwa on 07/11/22.
//

import CloudKit
import Foundation
import RxSwift
class LoadingScreenViewModel {
    private var multipleChoiceVM: MultipleChoiceViewModel?
    private let arrangeWordVM: ArrangeWordViewModel
    public private(set) var currentProgress: CGFloat
    public var totalFetchTask: Int
    var isLoading = BehaviorSubject<Bool>(value: true)
    var totalFetchCompleted = BehaviorSubject(value: 0)
    private let disposeBag = DisposeBag()
    init() {
        currentProgress = 0.0
        totalFetchTask = 2
        arrangeWordVM = ArrangeWordViewModel()
    }
    func incrementProgress(by: CGFloat) {
        do {
            let numberOfFetchCompleted = try CGFloat(totalFetchCompleted.value())
            currentProgress += by + numberOfFetchCompleted
        }
        catch {
            print("...")
        }
    }
    
    func fetchRecordScenario(scenarioID: CKRecord.ID) {
        fetchMultipleChoiceRecord(scenarioID: scenarioID)
        fetchArrangeWordRecord(scenarioID: scenarioID)
    }
    private func fetchMultipleChoiceRecord(scenarioID: CKRecord.ID) {
        multipleChoiceVM = MultipleChoiceViewModel(scenarioRecordId: scenarioID)
        multipleChoiceVM?.publishMultipleChoiceAssets.subscribe(
            onError: { [weak self] error in
                self?.totalFetchCompleted.onError(error)
            }, onCompleted: { [weak self] in
            do {
                try self?.totalFetchCompleted.onNext((self?.totalFetchCompleted.value() ?? 0) + 1)
            }
            catch {
                print("Value not available")
            }
        }).disposed(by: disposeBag)
    }
    private func fetchArrangeWordRecord(scenarioID: CKRecord.ID) {
        arrangeWordVM.getSentencesFromScenario(scenarioID: scenarioID)
        arrangeWordVM.sentences.subscribe(
            onError: { [weak self] error in
                self?.totalFetchCompleted.onError(error)
            }, onCompleted: { [weak self] in
            do {
//                print("Value: \(try self.totalFetchCompleted.value())")
                try self?.totalFetchCompleted.onNext((self?.totalFetchCompleted.value() ?? 0) + 1)
            }
            catch {
                print("Value not available")
            }
        }).disposed(by: disposeBag)
    }
    
}
