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
    
    let loadingScreenVM = LoadingScreenViewModel()

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true

        guard let scenarioRecordId = scenarioRecordId else {
            print("Scenario nil")
            return
        }
        horizontalProgressBar.backgroundColor = .clear
        
        view.addSubview(backgroundImage)
        view.addSubview(horizontalProgressBar)
        view.addSubview(promptLabel)
        
        setProgressBarConstraint()
        setPromptLabelConstraint()
        updateProgress(scenarioID: scenarioRecordId)
    }
    
    private func updateProgress(scenarioID: CKRecord.ID) {
        let progressBarWidth = horizontalProgressBar.layer.bounds.size.width
        
        loadingScreenVM.fetchRecordScenario(scenarioID: scenarioID)
        loadingScreenVM.totalFetchCompleted.observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] totalFetchCompleted in
            
            if totalFetchCompleted > 0 {
                self?.loadingScreenVM.incrementProgress(by: progressBarWidth/3)
            }
            if totalFetchCompleted == self?.loadingScreenVM.totalFetchTask {
                self?.loadingScreenVM.finishLoadingProgress()
                self?.horizontalProgressBar.progressAnimation(initialValue: self?.loadingScreenVM.currentProgress ?? 0.0, finalValue: progressBarWidth, duration: 2)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self?.navigationController?.popViewController(animated: false)
                }
            }

            else {
                self?.horizontalProgressBar.progressAnimation(initialValue: self?.loadingScreenVM.currentProgress ?? 0.0, finalValue: self?.loadingScreenVM.currentProgress ?? 0.0 + progressBarWidth/3, duration: 2)
            }
        }, onError: { error in
            if let fetchError = error as? FetchError {
                print(fetchError.localizedDescription)
            }
            
        }).disposed(by: disposeBag)
    }
    
    private func setProgressBarConstraint() {
        horizontalProgressBar.anchor(top: backgroundImage.topAnchor, left: backgroundImage.leftAnchor, bottom: backgroundImage.bottomAnchor, right: backgroundImage.rightAnchor, paddingTop: ScreenSizeConfiguration.SCREEN_HEIGHT/2, paddingLeft: ScreenSizeConfiguration.SCREEN_WIDTH/7, paddingBottom: ScreenSizeConfiguration.SCREEN_HEIGHT/2.4,paddingRight: ScreenSizeConfiguration.SCREEN_WIDTH/7)
    }
    
    private func setPromptLabelConstraint() {
        promptLabel.centerX(inView: backgroundImage)
        promptLabel.anchor(top: backgroundImage.topAnchor, bottom: horizontalProgressBar.topAnchor, paddingTop: ScreenSizeConfiguration.SCREEN_HEIGHT/3)
    }
    
}
