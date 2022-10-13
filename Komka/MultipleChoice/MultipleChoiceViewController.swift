//
//  MultipleChoiceViewController.swift
//  Komka
//
//  Created by Ryan Vieri Kwa on 12/10/22.
//

import UIKit

class MultipleChoiceViewController: UIViewController {
    
    var currentScenario: String?
    private lazy var backBtn: UIButton = {
//        let button = UIView.createImageIconBtn(title: "", imgTitle: "BackBtn")
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.setImage(UIImage(named: "BackBtn"), for: .normal)
        button.addTarget(self, action: #selector(self.backBtnTapped), for: .touchUpInside)
        return button
    }()
    private lazy var backgroundImage = UIView.setImageView(imageName: "bg")
    private lazy var scenarioCoverImg: UIImageView = {
        let image = UIView.setImageView(imageName: currentScenario ?? "RuangMakanCover", contentMode: .scaleAspectFill, clipsToBound: true)
        image.addOverlay()
        return image
    }()
    private lazy var imageScenario = UIView.setImageView(imageName: "BadanSayaKotor", contentMode: .scaleAspectFit,clipsToBound: true)
    private lazy var promptLabel: UILabel = {
        let label = UIView.createLabel(text: "Apa yang harus saya lakukan?", fontSize: 40)
        label.textAlignment = .center
        return label
    }()
    private lazy var leftChoice = UIView.setImageView(imageName: "FullAnswerBox_Left", contentMode: .scaleAspectFit,clipsToBound: true)
    private lazy var rightChoice = UIView.setImageView(imageName: "FullAnswerBox_Right", contentMode: .scaleAspectFit,clipsToBound: true)
    
    private lazy var audioBtn: UIButton = {
//        let button = UIView.createImageIconBtn(title: "", imgTitle: "audioBtn")
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.setImage(UIImage(named: "audioBtn"), for: .normal)
        button.addTarget(self, action: #selector(self.audioBtnTapped), for: .touchUpInside)

        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        configureSubView()
        configureConstraint()
    }
    
    private func configureSubView(){
        view.addSubview(backgroundImage)
        view.addSubview(audioBtn)
        view.addSubview(backBtn)
        backgroundImage.addSubview(scenarioCoverImg)
        scenarioCoverImg.addSubview(imageScenario)

        
        backgroundImage.addSubview(promptLabel)
        backgroundImage.addSubview(leftChoice)
        backgroundImage.addSubview(rightChoice)
    }
    private func configureConstraint(){
        backgroundImage.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        scenarioCoverImg.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingBottom: ScreenSizeConfiguration.SCREEN_HEIGHT/2.2)
        backBtn.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: ScreenSizeConfiguration.SCREEN_HEIGHT/25, paddingLeft: ScreenSizeConfiguration.SCREEN_WIDTH/30)
        
        
        imageScenario.anchor(top: scenarioCoverImg.topAnchor, left: scenarioCoverImg.leftAnchor, bottom: scenarioCoverImg.bottomAnchor, right: scenarioCoverImg.rightAnchor,paddingTop: ScreenSizeConfiguration.SCREEN_HEIGHT/10,paddingLeft: ScreenSizeConfiguration.SCREEN_WIDTH/3, paddingRight: ScreenSizeConfiguration.SCREEN_WIDTH/3)
        audioBtn.anchor(top: scenarioCoverImg.topAnchor, left: imageScenario.rightAnchor, bottom: scenarioCoverImg.bottomAnchor, right: scenarioCoverImg.rightAnchor, paddingTop: (ScreenSizeConfiguration.SCREEN_HEIGHT/2.2), paddingLeft: -20, paddingRight: ScreenSizeConfiguration.SCREEN_WIDTH/5)
        
        promptLabel.anchor(top:scenarioCoverImg.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingBottom: ScreenSizeConfiguration.SCREEN_HEIGHT/3)
        leftChoice.anchor(top:promptLabel.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingRight: ScreenSizeConfiguration.SCREEN_WIDTH/2)
        rightChoice.anchor(top:promptLabel.bottomAnchor, left: leftChoice.rightAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
    }
    @objc
    private func audioBtnTapped(_ sender: UIButton) {
        print("AudioDoSomething")
    }
    @objc
    private func backBtnTapped(_ sender: UIButton) {
        print("backBtnDoSomething")
        self.navigationController?.popViewController(animated: true)
    }
}
