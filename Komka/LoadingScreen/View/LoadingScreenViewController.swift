//
//  LoadingScreenViewController.swift
//  Komka
//
//  Created by Ryan Vieri Kwa on 03/11/22.
//

import CloudKit
import UIKit
import RxSwift

class LoadingScreenViewController: ViewController, ErrorViewDelegate {
    
    var scenarioRecordId: CKRecord.ID?
    
    let promptLabel = UIView.createLabel(text: "Tunggu Sebentar . . .", fontSize: 45.0)
    let backgroundImage = UIView.createImageView(imageName: "bg")
    var horizontalProgressBar = HorizontalProgressBarView(frame: CGRect(x: 0, y: 0, width: ScreenSizeConfiguration.SCREEN_WIDTH/1.45, height: ScreenSizeConfiguration.SCREEN_HEIGHT/15))
    
    var loadingScreenVM: LoadingScreenViewModel?

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true

        guard let scenarioRecordId = scenarioRecordId else {
            print("Scenario nil")
            return
        }
        loadingScreenVM = LoadingScreenViewModel()
        guard let loadingScreenVM = loadingScreenVM else {
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
        guard let loadingScreenVM = loadingScreenVM else {
            return
        }
        loadingScreenVM.fetchRecordScenario(scenarioID: scenarioID)
        loadingScreenVM.totalFetchCompleted.observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] totalFetchCompleted in
            guard let loadingScreenVM = self?.loadingScreenVM else {
                return
            }
            if totalFetchCompleted > 0 && totalFetchCompleted < loadingScreenVM.totalFetchTask{
                loadingScreenVM.incrementProgress(by: progressBarWidth/3)
            }
            if totalFetchCompleted == loadingScreenVM.totalFetchTask {
                loadingScreenVM.finishLoadingProgress()
                self?.horizontalProgressBar.progressAnimation(initialValue: loadingScreenVM.currentProgress ?? 0.0, finalValue:  ScreenSizeConfiguration.SCREEN_WIDTH/1.45, duration: 1)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self?.navigationController?.popViewController(animated: false)
                }
            }

            else {
                self?.horizontalProgressBar.progressAnimation(initialValue: loadingScreenVM.currentProgress ?? 0.0, finalValue: loadingScreenVM.currentProgress ?? 0.0 + progressBarWidth/3, duration: 1)
            }
        }, onError: { [weak self] error in
            if let fetchError = error as? FetchError {
                let errorView = ErrorViewController()
                errorView.delegate = self
                errorView.errorDescription = fetchError.localizedDescription
                errorView.errorTitleMessage = fetchError.errorTitle
                errorView.errorGuidance = fetchError.errorGuidance
                self?.navigationController?.pushViewController(errorView, animated: false)
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
    
    //Delegate
    func closeBtnTapped() {
        self.navigationController?.popToViewController(ChooseScenarioController.self)
    }
    
    func cobaLagiBtnTapped() {
        self.navigationController?.popToViewController(LoadingScreenViewController.self)
    }

}
