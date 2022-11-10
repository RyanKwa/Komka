//
//  FullSentencesViewController.swift
//  Komka
//
//  Created by Minawati on 13/10/22.
//

import UIKit
import CloudKit
import RxSwift

class FullSentencesViewController: ViewController {
    
    private var fullSentenceVM = FullSentencesViewModel()
    private var scenarioCoverImage, fullSentenceCharacterImage: UIImage?
    private var fullSentenceText: String?
    
    lazy private var backgroundImg = UIView.createImageView(imageName: "bg")
    lazy private var instructionLbl = UIView.createLabel(text: "Mari mulai belajar kata dibawah ini", fontSize: 40)
    
    lazy private var scenarioCoverImg: UIImageView = {
        let image = UIView.createImageView(image: scenarioCoverImage ?? UIImage(), contentMode: .scaleAspectFill, clipsToBound: true)
        image.addWhiteOverlay()
        return image
    }()
    lazy private var scenarioImg = UIView.createImageView(image: fullSentenceCharacterImage ?? UIImage(), contentMode: .scaleAspectFill, clipsToBound: true)
    
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
        navigationController?.isNavigationBarHidden = true
        fullSentenceVM.getScenarioSentence()
        fullSentenceVM.getFullSentenceAssets()
        setUpFullSentenceData()
        setupView()
        setupConstraint()
    }
    
    private func setUpFullSentenceData(){
        scenarioCoverImage = UIImage.changeImageFromURL(baseImage: fullSentenceVM.getFullSentenceAssetPart(.scenarioCover))
        fullSentenceCharacterImage = UIImage.changeImageFromURL(baseImage: fullSentenceVM.getFullSentenceAssetPart(.fullSentenceCharacter))
        fullSentenceText = fullSentenceVM.getSentence()
    }
    
    private func setupView() {
        view.addSubview(backgroundImg)
        backgroundImg.addSubview(scenarioCoverImg)
        scenarioCoverImg.addSubview(instructionLbl)
        scenarioCoverImg.addSubview(scenarioImg)
        
        view.addSubview(audioBtn)
        view.addSubview(backBtn)

        backgroundImg.addSubview(fullSentenceLbl)
        view.addSubview(startBtn)
    }
    
    private func setupConstraint(){
        backgroundImg.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        scenarioCoverImg.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingBottom: ScreenSizeConfiguration.SCREEN_HEIGHT/2.2)
        instructionLbl.centerX(inView: view, topAnchor: view.topAnchor, paddingTop: ScreenSizeConfiguration.SCREEN_HEIGHT/18)
        
        scenarioImg.anchor(bottom: scenarioCoverImg.bottomAnchor)
        scenarioImg.centerX(inView: scenarioCoverImg)
        scenarioImg.setDimensions(width: ScreenSizeConfiguration.SCREEN_WIDTH/2.99, height: ScreenSizeConfiguration.SCREEN_HEIGHT/2.51)
        
        audioBtn.anchor(left: scenarioImg.rightAnchor, bottom: scenarioCoverImg.bottomAnchor, right: scenarioCoverImg.rightAnchor, paddingLeft: -20, paddingBottom: 10, paddingRight: ScreenSizeConfiguration.SCREEN_WIDTH/5)
        backBtn.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: ScreenSizeConfiguration.SCREEN_HEIGHT/25, paddingLeft: ScreenSizeConfiguration.SCREEN_WIDTH/30)
        
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
        self.navigationController?.pushViewController(SoundPracticeViewController(), animated: false)
    }
}
