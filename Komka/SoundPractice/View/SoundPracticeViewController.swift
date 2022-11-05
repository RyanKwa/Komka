//
//  SoundPracticeViewController.swift
//  Komka
//
//  Created by Minawati on 13/10/22.
//

import UIKit

class SoundPracticeViewController: UIViewController {
    
    private lazy var queue = ["Saya", "Mandi"]
    private lazy var word: [String] = [queue[queueWordCounter-1]]
    
    private lazy var queueWordCounter: Int = 1
    private lazy var progressFrom = 0.0
    private lazy var progressTo = 1.0
    
    private lazy var circularProgressBarView = CircularProgressBarView(frame: .zero)

    private lazy var backgroundImg = UIView.createImageView(imageName: "bg")
    private lazy var instructionLbl = UIView.createLabel(text: "Coba ikuti cara baca di bawah ini", fontSize: 40)
    
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
    
    @objc func backBtnTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @objc func audioBtnTapped(_ sender: UIButton) {
        TextToSpeechService.shared.stopSpeech()
        TextToSpeechService.shared.startSpeech(word)
    }
    
    func setUpCircularProgressBarView() {
        circularProgressBarView.duration = 10
        circularProgressBarView.progressAnimation(progressFrom: progressFrom, progressTo: progressTo)
        circularProgressBarView.currentWordBg = "CurrentWordBgPlaceholder"
    }
    
    private func setUpConstraint(){
        backgroundImg.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        backBtn.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: ScreenSizeConfiguration.SCREEN_HEIGHT/25, paddingLeft: ScreenSizeConfiguration.SCREEN_WIDTH/30)
        
        instructionLbl.centerX(inView: view, topAnchor: view.topAnchor, paddingTop: ScreenSizeConfiguration.SCREEN_HEIGHT/17)
                
        circularProgressBarView.centerX(inView: view)
        circularProgressBarView.anchor(top: instructionLbl.bottomAnchor, right: audioBtn.leftAnchor, paddingTop: ScreenSizeConfiguration.SCREEN_HEIGHT/20, paddingRight: ScreenSizeConfiguration.SCREEN_WIDTH/20, width: ScreenSizeConfiguration.SCREEN_WIDTH/2, height: ScreenSizeConfiguration.SCREEN_HEIGHT/1.5)
        
        audioBtn.anchor(top: instructionLbl.bottomAnchor, left: circularProgressBarView.rightAnchor, paddingTop: ScreenSizeConfiguration.SCREEN_HEIGHT/17, paddingLeft: ScreenSizeConfiguration.SCREEN_WIDTH/20)
        
    }

    private func addSubViews(){
        view.addSubview(backgroundImg)
        view.addSubview(backBtn)
        view.addSubview(instructionLbl)
        view.addSubview(circularProgressBarView)
        view.addSubview(audioBtn)
    }
        
    func moveToNextPage(){
        DispatchQueue.main.asyncAfter(deadline: .now() + (circularProgressBarView.duration ?? 0)) {
            if(self.progressTo == 1) {
                if(self.queueWordCounter == self.queue.count){
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.navigationController?.pushViewController(ViewController(), animated: true)
                    }
                }
                else {
                    let vc = SoundPracticeViewController()
                    vc.queueWordCounter += 1
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setUpCircularProgressBarView()
        addSubViews()
        setUpConstraint()
        moveToNextPage()
    }
}
