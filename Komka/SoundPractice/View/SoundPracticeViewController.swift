//
//  SoundPracticeViewController.swift
//  Komka
//
//  Created by Minawati on 13/10/22.
//

import UIKit
import CloudKit

class SoundPracticeViewController: UIViewController {
   
    var selectedScenarioId: CKRecord.ID?
    
    lazy private var soundPracticeVM: SoundPracticeViewModel = SoundPracticeViewModel(scenarioRecordId: selectedScenarioId ?? CKRecord.ID(recordName: RecordType.Scenario.rawValue))
    private var scenarioCoverImage, soundPracticeCharacterImage: UIImage?
    private var wordText: String = ""
    
    private var audioPermission = AudioPermission()
    
    private lazy var circularProgressBarView = CircularProgressBarView(frame: .zero, wordText: wordText, scenarioCoverImage: scenarioCoverImage ?? UIImage(), soundPracticeCharacterImage: soundPracticeCharacterImage ?? UIImage())

    private lazy var backgroundImg = UIView.createImageView(imageName: "bg")
    private lazy var instructionLbl = UIView.createLabel(text: "Coba ikuti cara baca di bawah ini", fontSize: 40)
    
    private lazy var nextBtn: UIButton = {
        let button = Button(style: .active, title: "Lanjut")
        button.setBackgroundImage(UIImage(named: "LanjutMulaiBtn"), for: .normal)
        
        button.addTarget(self, action: #selector(nextBtnTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var backBtn: UIButton = {
        let button = UIView.createImageIconBtn(imgTitle: "BackBtn")
        button.addTarget(self, action: #selector(backBtnTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var audioBtn: UIButton = {
        let button = UIView.createImageIconBtn(imgTitle: "audioBtn")
        button.addTarget(self, action: #selector(audioBtnTapped), for: .touchUpInside)
        
        return button
    }()
    
    @objc func nextBtnTapped(_ sender: UIButton) {
        let stepViewController = ArrangeWordViewController()
        stepViewController.selectedScenarioId = self.selectedScenarioId
        self.navigationController?.pushViewController(stepViewController, animated: false)
    }
    
    @objc func backBtnTapped(_ sender: UIButton) {
        SoundEffectService.shared.playSoundEffect(.Bubble)
        navigationController?.popViewController(animated: false)
    }

    
    @objc func audioBtnTapped(_ sender: UIButton) {
        soundPracticeVM.playTextToSpeech(wordCounter: soundPracticeVM.queueWordCounter)
    }
    
    func setUpCircularProgressBarView() {
        circularProgressBarView.duration = 1
        circularProgressBarView.progressAnimation(progressFrom: soundPracticeVM.progressFrom, progressTo: soundPracticeVM.progressTo)
    }
    
    private func setUpConstraint(){
        backgroundImg.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        backBtn.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: ScreenSizeConfiguration.SCREEN_HEIGHT/25, paddingLeft: ScreenSizeConfiguration.SCREEN_WIDTH/30)
    }

    private func addSubViews(){
        view.addSubview(backgroundImg)
        view.addSubview(backBtn)        
        soundPracticeVM.publishSoundPracticeAssets.subscribe(onNext: { _ in
            DispatchQueue.main.async { [self] in
                wordText = soundPracticeVM.getSoundPracticeWord(wordCounter: soundPracticeVM.queueWordCounter)
                scenarioCoverImage = UIImage.changeImageFromURL(baseImage: soundPracticeVM.getSoundPracticeAssetPart(wordText: AssetStepType.Cover.rawValue, soundPracticePart: .scenarioCover))
                soundPracticeCharacterImage = UIImage.changeImageFromURL(baseImage: soundPracticeVM.getSoundPracticeAssetPart(wordText: wordText, soundPracticePart: .soundPracticeCharacter))
                circularProgressBarView = CircularProgressBarView(frame: .zero, wordText: wordText, scenarioCoverImage: scenarioCoverImage ?? UIImage(), soundPracticeCharacterImage: soundPracticeCharacterImage ?? UIImage())
                
                view.addSubview(instructionLbl)
                view.addSubview(circularProgressBarView)
                view.addSubview(audioBtn)
                
                instructionLbl.centerX(inView: view, topAnchor: view.topAnchor, paddingTop: ScreenSizeConfiguration.SCREEN_HEIGHT/17)
                
                circularProgressBarView.centerX(inView: view)
                circularProgressBarView.anchor(top: instructionLbl.bottomAnchor, right: audioBtn.leftAnchor, paddingTop: ScreenSizeConfiguration.SCREEN_HEIGHT/20, paddingRight: ScreenSizeConfiguration.SCREEN_WIDTH/20, width: ScreenSizeConfiguration.SCREEN_WIDTH/2, height: ScreenSizeConfiguration.SCREEN_HEIGHT/1.5)
                
                audioBtn.anchor(top: instructionLbl.bottomAnchor, left: circularProgressBarView.rightAnchor, paddingTop: ScreenSizeConfiguration.SCREEN_HEIGHT/17, paddingLeft: ScreenSizeConfiguration.SCREEN_WIDTH/20)
                
                nextBtn.anchor(bottom: view.bottomAnchor, right: view.rightAnchor, paddingBottom: ScreenSizeConfiguration.SCREEN_HEIGHT/10, paddingRight: ScreenSizeConfiguration.SCREEN_WIDTH/10)

            }
        })
        .disposed(by: soundPracticeVM.disposeBag)
    }
        
    func moveToNextPage(){
        DispatchQueue.main.asyncAfter(deadline: .now() + (circularProgressBarView.duration ?? 0)) {
            if(self.soundPracticeVM.progressTo == 1) {
                if(self.soundPracticeVM.queueWordCounter == self.soundPracticeVM.words.count){
                    self.nextBtn.isHidden = false
                }
                else {
                    let vc = SoundPracticeViewController()
                    self.soundPracticeVM.queueWordCounter += 1
                    vc.soundPracticeVM.queueWordCounter = self.soundPracticeVM.queueWordCounter
                    vc.selectedScenarioId = self.selectedScenarioId
                    self.navigationController?.pushViewController(vc, animated: false)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioPermission.requestPermission()
        navigationController?.isNavigationBarHidden = true
        
        soundPracticeVM.getScenario()
        soundPracticeVM.getSoundPracticeAssets()
        
        nextBtn.isHidden = true

        setUpCircularProgressBarView()
        addSubViews()
        setUpConstraint()
        moveToNextPage()
    }
}
