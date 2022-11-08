//
//  LoadingScreenViewController.swift
//  Komka
//
//  Created by Ryan Vieri Kwa on 03/11/22.
//

import CloudKit
import UIKit
import RxSwift

class LoadingScreenViewController: UIViewController {
    var scenarioRecordId: CKRecord.ID?
    
    let promptLabel = UIView.createLabel(text: "Tunggu Sebentar . . .", fontSize: 45.0)
    let backgroundImage = UIView.createImageView(imageName: "bg")
    var horizontalProgressBar = HorizontalProgressBarView(frame: CGRect(x: 0, y: 0, width: ScreenSizeConfiguration.SCREEN_WIDTH/1.45, height: ScreenSizeConfiguration.SCREEN_HEIGHT/15))
    private var currentProgress = 0.0
    
    var multipleChoiceVM: MultipleChoiceViewModel?
    let arrangeWordVM = ArrangeWordViewModel()
    //    var currentProgress = BehaviorSubject<CGFloat>(value: 0)
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        let progressBarWidth = horizontalProgressBar.layer.bounds.size.width
        guard let scenarioRecordId = scenarioRecordId else {
            //error
            print("Scenario nil")
            return
        }
        horizontalProgressBar.backgroundColor = .clear
        view.addSubview(backgroundImage)
        view.addSubview(horizontalProgressBar)
        view.addSubview(promptLabel)
        setProgressBarConstraint()
        setPromptLabelConstraint()
        let loadingScreenVM = LoadingScreenViewModel()
        loadingScreenVM.fetchRecordScenario(scenarioID: scenarioRecordId)
        loadingScreenVM.totalFetchCompleted.subscribe(onNext: { numberOfFetchTasked in
            print(numberOfFetchTasked)
            if numberOfFetchTasked > 0 {
                loadingScreenVM.incrementProgress(by: progressBarWidth/3)
            }
        })
        loadingScreenVM.totalFetchCompleted.observe(on: MainScheduler.instance).subscribe(onNext: { totalFetchCompleted in
            // MARK: Kalau udah ke fetched semua
            if totalFetchCompleted == loadingScreenVM.totalFetchTask {
                loadingScreenVM.isLoading.onNext(false)
                loadingScreenVM.totalFetchCompleted.onCompleted()
                loadingScreenVM.isLoading.onCompleted()
                
                self.horizontalProgressBar.progressAnimation(initialValue: loadingScreenVM.currentProgress, finalValue: progressBarWidth, duration: 2)
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            // MARK: Lagi ngefetch, sambil jalanin progressnya
            else {
                self.horizontalProgressBar.progressAnimation(initialValue: loadingScreenVM.currentProgress, finalValue: loadingScreenVM.currentProgress + progressBarWidth/3, duration: 2)
            }
        }, onError: { error in
            if let fetchError = error as? FetchError {
                print(fetchError.description)
            }
        }).disposed(by: disposeBag)
    }
    
    func setProgressBarConstraint() {
        horizontalProgressBar.anchor(top: backgroundImage.topAnchor, left: backgroundImage.leftAnchor, bottom: backgroundImage.bottomAnchor, right: backgroundImage.rightAnchor, paddingTop: ScreenSizeConfiguration.SCREEN_HEIGHT/2, paddingLeft: ScreenSizeConfiguration.SCREEN_WIDTH/7, paddingBottom: ScreenSizeConfiguration.SCREEN_HEIGHT/2.4,paddingRight: ScreenSizeConfiguration.SCREEN_WIDTH/7)
        print("Width: \(horizontalProgressBar.layer.bounds.size.width)")
        print("height: \(horizontalProgressBar.height)")
        
    }
    func setPromptLabelConstraint() {
        promptLabel.centerX(inView: backgroundImage)
        promptLabel.anchor(top: backgroundImage.topAnchor, bottom: horizontalProgressBar.topAnchor, paddingTop: ScreenSizeConfiguration.SCREEN_HEIGHT/3)
    }
    
    func trash() {
        //MARK: Fetching
        //TODO: fetch multipleChoiceData from multipleChoiceVM
        //        var currentProgress = 0.0
        //        self.multipleChoiceVM = MultipleChoiceViewModel(scenarioRecordId: scenarioRecordId)
        //
        //        multipleChoiceVM?.publishMultipleChoiceAssets.subscribe(onNext: { asset in
        //            print("ASSET LODING: \(asset)")
        //
        //        },onError: { error in
        //
        //        }, onCompleted: { [weak self] in
        //            DispatchQueue.main.async {
        //                self?.horizontalProgressBar.progressAnimation(initialValue: 0.0, finalValue: 260.0, duration: 2)
        //                self?.currentProgress.onNext(260.0)
        //            }
        //        }).disposed(by: disposeBag)
        
        //TODO: fetch scenario from scenarioVM
        //        let increment = 0.0
        //        print("increment: \(increment)")
        
        
        //        arrangeWordVM.getSentencesFromScenario(scenarioID: "4E4252E5-99B4-3971-C57F-97268D35B009")
        //        arrangeWordVM.sentences.delay(RxTimeInterval.seconds(2), scheduler: MainScheduler.instance)
        //            .subscribe(onNext: { [weak self] sentence in
        //            print(sentence)
        //        }, onError: { error in
        //            let errorMessage = error as? FetchError
        //            print("Error: \(errorMessage?.localizedDescription)")
        //        }, onCompleted: { [weak self] in
        //            DispatchQueue.main.async {
        //                self?.horizontalProgressBar.progressAnimation(initialValue: 260.0, finalValue: progressBarWidth, duration: 2)
        //                self?.currentProgress.onNext(progressBarWidth)
        //            }
        //        })
        //        .disposed(by: disposeBag)
        
        //        Observable.combineLatest(currentProgress, arrangeWordVM.isLoading, resultSelector: { progress, isLoading in
        //            print("Progress: \(progress) LoadingState: \(isLoading)")
        //            if isLoading == false && progress == progressBarWidth {
        //                DispatchQueue.main.asyncAfter(deadline: .now() + 3){
        //                    self.navigationController?.popViewController(animated: false)
        //                }
        //            }
        //        }).subscribe()
        //            .disposed(by: disposeBag)
        
        //TODO: fetch asset from assetVM
    }
}
