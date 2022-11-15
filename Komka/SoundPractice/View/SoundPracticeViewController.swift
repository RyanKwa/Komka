//
//  SoundPracticeViewController.swift
//  Komka
//
//  Created by Minawati on 13/10/22.
//

import UIKit
import CloudKit
import RxSwift
import AVFoundation

class SoundPracticeViewController: ViewController {
    private var soundPracticeVM = SoundPracticeViewModel()
    
    private var scenarioCoverImage, soundPracticeCharacterImage: UIImage?
    private var wordText: String = ""
        
    private lazy var circularProgressBarView = CircularProgressBarView(frame: .zero, wordText: wordText, scenarioCoverImage: scenarioCoverImage ?? UIImage(), soundPracticeCharacterImage: soundPracticeCharacterImage ?? UIImage())
    
    private lazy var backgroundImg = UIView.createImageView(imageName: "bg")
    private lazy var instructionLbl = UIView.createLabel(text: "Ulangi kata dibawah ini", fontSize: 40)
    
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
        soundPracticeVM.stopTextToSpeech()
        soundPracticeVM.stopSoundPractice()
        let stepViewController = ArrangeWordViewController()
        self.navigationController?.pushViewController(stepViewController, animated: false)
    }
    
    @objc func backBtnTapped(_ sender: UIButton) {
        soundPracticeVM.stopTextToSpeech()
        SoundEffectService.shared.playSoundEffect(.Bubble)
        navigationController?.popViewController(animated: false)
    }
    
    @objc func audioBtnTapped(_ sender: UIButton) {
        soundPracticeVM.playTextToSpeech(wordCounter: soundPracticeVM.queueWordCounter)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.soundPracticeVM.startSoundPractice()
        }
    }
    
    func setUpCircularProgressBarView() {
        circularProgressBarView.progressAnimation(progressFrom: soundPracticeVM.currentProgress, progressTo: soundPracticeVM.progressTo, duration: soundPracticeVM.duration)
    }
    
    private func setUpSoundPracticeData(){
        wordText = soundPracticeVM.getSoundPracticeWord(wordCounter: soundPracticeVM.queueWordCounter)
        scenarioCoverImage = UIImage.changeImageFromURL(baseImage: soundPracticeVM.getSoundPracticeAssetPart(wordText: AssetStepType.Cover.rawValue, soundPracticePart: .scenarioCover))
        soundPracticeCharacterImage = UIImage.changeImageFromURL(baseImage: soundPracticeVM.getSoundPracticeAssetPart(wordText: wordText, soundPracticePart: .soundPracticeCharacter))
        circularProgressBarView = CircularProgressBarView(frame: .zero, wordText: wordText, scenarioCoverImage: scenarioCoverImage ?? UIImage(), soundPracticeCharacterImage: soundPracticeCharacterImage ?? UIImage())
    }
    
    private func setUpConstraint(){
        backgroundImg.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        backBtn.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: ScreenSizeConfiguration.SCREEN_HEIGHT/25, paddingLeft: ScreenSizeConfiguration.SCREEN_WIDTH/30)
        instructionLbl.centerX(inView: view, topAnchor: view.topAnchor, paddingTop: ScreenSizeConfiguration.SCREEN_HEIGHT/18)

        circularProgressBarView.centerX(inView: view)
        circularProgressBarView.anchor(top: instructionLbl.bottomAnchor, paddingTop: ScreenSizeConfiguration.SCREEN_HEIGHT/30, width: ScreenSizeConfiguration.SCREEN_WIDTH/1.5, height: ScreenSizeConfiguration.SCREEN_HEIGHT/1.2)
        
        audioBtn.anchor(top: circularProgressBarView.topAnchor, right: view.rightAnchor, paddingRight: 230)
        
        nextBtn.anchor(bottom: view.bottomAnchor, right: view.rightAnchor, paddingBottom: ScreenSizeConfiguration.SCREEN_HEIGHT/10, paddingRight: ScreenSizeConfiguration.SCREEN_WIDTH/10)
    }
    
    private func addSubViews(){
        view.addSubview(backgroundImg)
        view.addSubview(backBtn)
        view.addSubview(instructionLbl)
        view.addSubview(circularProgressBarView)
        view.addSubview(audioBtn)
        view.addSubview(nextBtn)
    }
    
    private func moveToNextPage(){
        soundPracticeVM.progressPublisher.observe(on: MainScheduler.instance).subscribe(onCompleted:  { [self] in
            if(soundPracticeVM.queueWordCounter == soundPracticeVM.words.count){
                soundPracticeVM.stopSoundPractice()
                nextBtn.isHidden = false
            }
            else {
                let vc = SoundPracticeViewController()
                soundPracticeVM.queueWordCounter += 1
                vc.soundPracticeVM.queueWordCounter = soundPracticeVM.queueWordCounter
                soundPracticeVM.stopSoundPractice()
                navigationController?.pushViewController(vc, animated: false)
            }
        }).disposed(by: soundPracticeVM.disposeBag)
    }
    
    private func updateProgress(){
        soundPracticeVM.calculateProgress()
        
        soundPracticeVM.confidenceResultPublisher.observe(on: MainScheduler.instance).subscribe { [self] progress in
            soundPracticeVM.setProgress(progress)
            circularProgressBarView.progressAnimation(progressFrom: soundPracticeVM.currentProgress, progressTo: soundPracticeVM.progressTo, duration: soundPracticeVM.duration)
        }.disposed(by: soundPracticeVM.disposeBag)
    }
    
    private func permissionDenied(){
        let alert = UIAlertController(title: "Izinkan Komka untuk akses mikrofon", message: "Aktifkan mikrofon untuk menggunakan fitur palatihan suara", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Buka pengaturan", style: .default, handler: { action in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }))
        
        alert.addAction(UIAlertAction(title: "Batalkan", style: .cancel, handler: { action in
            self.navigationController?.popViewController(animated: false)
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    private func permissionGranted(){
        updateProgress()
        soundPracticeVM.setSoundAnalyzer()
        soundPracticeVM.startSoundPractice()
    }
    
    private func micPermission(){
        switch AVAudioSession.sharedInstance().recordPermission {
        case .granted:
            permissionGranted()
        case .denied:
            permissionDenied()
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission({ granted in
                DispatchQueue.main.async { [self] in
                    if granted {
                        permissionGranted()
                    }
                    else {
                        permissionDenied()
                    }
                }
            })
        @unknown default:
            print("Unknown case")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        
        soundPracticeVM.getScenario()
        soundPracticeVM.getSoundPracticeAssets()
        
        setUpSoundPracticeData()

        micPermission()
        
        nextBtn.isHidden = true
        
        setUpCircularProgressBarView()
        
        addSubViews()
        setUpConstraint()
        moveToNextPage()
    }
}
