//
//  FullSentencesViewController.swift
//  Komka
//
//  Created by Minawati on 13/10/22.
//

import UIKit

class FullSentencesViewController: UIViewController {
    
    lazy private var queue = ["Saya mandi"]
    
    lazy private var backgroundImg = UIView.createImageView(imageName: "bg")
    lazy private var scenarioCoverImg: UIImageView = {
        let image = UIView.createImageView(imageName: "KamarMandiCover", contentMode: .scaleAspectFill, clipsToBound: true)
        image.addWhiteOverlay()
        
        return image
    }()
    lazy private var scenarioImg = UIView.createImageView(imageName: "Mandi", contentMode: .scaleAspectFit,clipsToBound: true)
    
    private lazy var fullSentenceLbl = UIView.createLabel(text: "Saya mandi", fontSize: 40)
    
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
    
    @objc func audioBtnTapped(_ sender: UIButton) {
        TextToSpeechService.shared.stopSpeech()
        TextToSpeechService.shared.startSpeech(queue)
    }
    
    @objc func backBtnTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: false)
    }
    
    @objc func startBtnTapped(_ sender: UIButton) {
        navigationController?.pushViewController(SoundPracticeViewController(), animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraint()
    }
    
    private func setupView() {
        view.addSubview(backgroundImg)
        backgroundImg.addSubview(scenarioCoverImg)
        scenarioCoverImg.addSubview(scenarioImg)
        view.addSubview(audioBtn)
        view.addSubview(backBtn)
        
        backgroundImg.addSubview(fullSentenceLbl)
        backgroundImg.addSubview(startBtn)
    }
    
    private func setupConstraint(){
        backgroundImg.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        scenarioCoverImg.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingBottom: ScreenSizeConfiguration.SCREEN_HEIGHT/2.2)
        scenarioImg.anchor(top: scenarioCoverImg.topAnchor, left: scenarioCoverImg.leftAnchor, bottom: scenarioCoverImg.bottomAnchor, right: scenarioCoverImg.rightAnchor,paddingTop: ScreenSizeConfiguration.SCREEN_HEIGHT/10,paddingLeft: ScreenSizeConfiguration.SCREEN_WIDTH/3, paddingRight: ScreenSizeConfiguration.SCREEN_WIDTH/3)
        
        backBtn.anchor(top: scenarioCoverImg.topAnchor, left: scenarioCoverImg.leftAnchor, paddingTop: ScreenSizeConfiguration.SCREEN_HEIGHT/25, paddingLeft: ScreenSizeConfiguration.SCREEN_WIDTH/30)
        audioBtn.anchor(top: scenarioCoverImg.topAnchor, left: scenarioImg.rightAnchor, bottom: scenarioCoverImg.bottomAnchor, right: scenarioCoverImg.rightAnchor, paddingTop: (ScreenSizeConfiguration.SCREEN_HEIGHT/2.2), paddingLeft: -20, paddingRight: ScreenSizeConfiguration.SCREEN_WIDTH/5)
        
        fullSentenceLbl.anchor(top:scenarioCoverImg.bottomAnchor, bottom: view.bottomAnchor, paddingBottom: ScreenSizeConfiguration.SCREEN_HEIGHT/3.5)
        fullSentenceLbl.centerX(inView: view)
        
        startBtn.setDimensions(width: ScreenSizeConfiguration.SCREEN_WIDTH/4.44, height: ScreenSizeConfiguration.SCREEN_HEIGHT/9)
        startBtn.anchor(top: fullSentenceLbl.bottomAnchor, paddingTop: ScreenSizeConfiguration.SCREEN_HEIGHT/45)
        startBtn.centerX(inView: view)
    }
}
