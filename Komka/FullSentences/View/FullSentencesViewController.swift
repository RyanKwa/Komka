//
//  FullSentencesViewController.swift
//  Komka
//
//  Created by Minawati on 13/10/22.
//

import UIKit
import CloudKit
import RxSwift

class FullSentencesViewController: UIViewController {
    
    var selectedScenarioId: CKRecord.ID?
    
    lazy private var fullSentenceVM: FullSentencesViewModel = FullSentencesViewModel(scenarioRecordId: selectedScenarioId ?? CKRecord.ID(recordName: RecordType.Scenario.rawValue))
    private var scenarioCoverImage, fullSentenceCharacterImage: UIImage?
    private var fullSentenceText: String?
    
    lazy private var backgroundImg = UIView.createImageView(imageName: "bg")
    lazy private var scenarioCoverImg: UIImageView = {
        let image = UIView.createImageView(image: scenarioCoverImage ?? UIImage(), contentMode: .scaleAspectFill, clipsToBound: true)
        image.addWhiteOverlay()
        return image
    }()
    lazy private var scenarioImg = UIView.createImageView(image: fullSentenceCharacterImage ?? UIImage(), contentMode: .scaleAspectFit,clipsToBound: true)
    
    lazy private var fullSentenceLbl = UIView.createLabel(text: fullSentenceText ?? "", fontSize: 40)
    
    lazy private var startBtn: UIButton = {
        let button = LevelButton()
        button.configure(with: LevelButtonVM(title: "Mulai", image: "LanjutMulaiBtn", size: 30))
        button.addTarget(self, action: #selector(startBtnTapped), for: .touchUpInside)
        
        return button
    }()
    
    lazy private var audioBtn: UIButton = {
        let button = UIView.createImageIconBtn(imgTitle: "audioBtn")
        button.addTarget(self, action: #selector(audioBtnTapped), for: .touchUpInside)
        
        return button
    }()
    
    lazy private var backBtn: UIButton = {
        let button = UIView.createImageIconBtn(imgTitle: "BackBtn")
        button.addTarget(self, action: #selector(backBtnTapped), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fullSentenceVM.getScenario()
        fullSentenceVM.getFullSentenceAssets()
        
        setupView()
    }
    
    private func setupView() {
        view.addSubview(backgroundImg)
        view.addSubview(backBtn)
        backgroundImg.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        backBtn.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: ScreenSizeConfiguration.SCREEN_HEIGHT/25, paddingLeft: ScreenSizeConfiguration.SCREEN_WIDTH/30)
        
        Observable.combineLatest(fullSentenceVM.publishFullSentenceAssets, fullSentenceVM.publishFullSentence, resultSelector: { assets, scenario in
            DispatchQueue.main.async { [self] in
                scenarioCoverImage = UIImage.changeImageFromURL(baseImage: fullSentenceVM.getFullSentenceAssetPart(.scenarioCover))
                fullSentenceCharacterImage = UIImage.changeImageFromURL(baseImage: fullSentenceVM.getFullSentenceAssetPart(.fullSentenceCharacter))
                fullSentenceText = fullSentenceVM.getSentence()
                
                view.addSubview(audioBtn)
                backgroundImg.addSubview(scenarioCoverImg)
                scenarioCoverImg.addSubview(scenarioImg)
                backgroundImg.addSubview(fullSentenceLbl)
                view.addSubview(startBtn)
                
                setupConstraint()
            }
        })
        .observe(on: MainScheduler.instance)
        .subscribe()
        .disposed(by: fullSentenceVM.disposeBag)
    }
    
    private func setupConstraint(){
        scenarioCoverImg.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingBottom: ScreenSizeConfiguration.SCREEN_HEIGHT/2.2)
        scenarioImg.anchor(top: scenarioCoverImg.topAnchor, left: scenarioCoverImg.leftAnchor, bottom: scenarioCoverImg.bottomAnchor, right: scenarioCoverImg.rightAnchor,paddingTop: ScreenSizeConfiguration.SCREEN_HEIGHT/10,paddingLeft: ScreenSizeConfiguration.SCREEN_WIDTH/3, paddingRight: ScreenSizeConfiguration.SCREEN_WIDTH/3)
        
        audioBtn.anchor(top: scenarioCoverImg.topAnchor, left: scenarioImg.rightAnchor, bottom: scenarioCoverImg.bottomAnchor, right: scenarioCoverImg.rightAnchor, paddingTop: (ScreenSizeConfiguration.SCREEN_HEIGHT/2.2), paddingLeft: -20, paddingRight: ScreenSizeConfiguration.SCREEN_WIDTH/5)
        
        fullSentenceLbl.anchor(top:scenarioCoverImg.bottomAnchor, bottom: view.bottomAnchor, paddingBottom: ScreenSizeConfiguration.SCREEN_HEIGHT/3.5)
        fullSentenceLbl.centerX(inView: view)
        
        startBtn.setDimensions(width: ScreenSizeConfiguration.SCREEN_WIDTH/4.44, height: ScreenSizeConfiguration.SCREEN_HEIGHT/9)
        startBtn.anchor(top: fullSentenceLbl.bottomAnchor, paddingTop: ScreenSizeConfiguration.SCREEN_HEIGHT/45)
        startBtn.centerX(inView: view)
    }
    
    @objc
    private func audioBtnTapped(_ sender: UIButton) {
        fullSentenceVM.playTextToSpeech()
    }
    
    @objc
    private func backBtnTapped(_ sender: UIButton) {
        SoundEffectService.shared.playSoundEffect(.Bubble)
        navigationController?.popViewController(animated: false)
    }
    
    @objc
    private func startBtnTapped(_ sender: UIButton) {
        SoundEffectService.shared.playSoundEffect(.Bubble)
        let stepViewController = SoundPracticeViewController()
        stepViewController.selectedScenarioId = selectedScenarioId
        self.navigationController?.pushViewController(stepViewController, animated: false)
    }
}
