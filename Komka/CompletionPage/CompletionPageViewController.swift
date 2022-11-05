//
//  CompletionPageViewController.swift
//  Komka
//
//  Created by Minawati on 05/11/22.
//

import UIKit
import SwiftConfettiView

class CompletionPageViewController: UIViewController {

    lazy private var backgroundImg = UIView.createImageView(imageName: "bg")
    lazy private var rewardImg = UIView.createImageView(imageName: "Piala")
    lazy private var confettiView = createConfettiView()
    lazy private var rectView = setRectView()
    
    lazy private var homeBtn: UIButton = {
        let button = UIView.createImageIconBtn(title: "Beranda", imgTitle: "BerandaBtn")
        button.addTarget(self, action: #selector(homeBtnTapped), for: .touchUpInside)
        
        return button
    }()
    lazy private var homeLbl = UIView.createLabel(text: "Beranda", fontSize: 25)
    
    lazy private var retryBtn: UIButton = {
        let button = UIView.createImageIconBtn(title: "Ulang", imgTitle: "UlangBtn")
        button.addTarget(self, action: #selector(retryBtnTapped), for: .touchUpInside)
        
        return button
    }()
    lazy private var retryLbl = UIView.createLabel(text: "Ulang", fontSize: 25)
    
    lazy private var homeStackView = UIView.createStackView(arrangedSubviews: [homeBtn, homeLbl], axis: .vertical, spacing: 10, alignment: .center)
    lazy private var retryStackView = UIView.createStackView(arrangedSubviews: [retryBtn, retryLbl], axis: .vertical, spacing: 10, alignment: .center)
    
    lazy private var horizontalStackView = UIView.createStackView(arrangedSubviews: [homeStackView, retryStackView], axis: .horizontal, spacing: 48, alignment: .center)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backgroundImg)
        view.addSubview(confettiView)
        view.addSubview(rewardImg)
        view.addSubview(rectView)
        view.addSubview(horizontalStackView)
        
        setupConstraint()
    }
    
    private func setupConstraint() {
        backgroundImg.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        rewardImg.anchor(top: view.topAnchor, paddingTop: ScreenSizeConfiguration.SCREEN_WIDTH/10.8, width: ScreenSizeConfiguration.SCREEN_WIDTH/1.89, height: ScreenSizeConfiguration.SCREEN_HEIGHT/2)
        rewardImg.centerX(inView: view)
        rectView.anchor(top: rewardImg.bottomAnchor, paddingTop: ScreenSizeConfiguration.SCREEN_HEIGHT/24, width: ScreenSizeConfiguration.SCREEN_WIDTH/2.68, height: ScreenSizeConfiguration.SCREEN_HEIGHT/4.5)
        rectView.centerX(inView: view)
        
        let btnWidth = ScreenSizeConfiguration.SCREEN_WIDTH/11.8
        let btnHeight = ScreenSizeConfiguration.SCREEN_HEIGHT/9.3
        
        homeBtn.setDimensions(width: btnWidth, height: btnHeight)
        retryBtn.setDimensions(width: btnWidth, height: btnHeight)
        horizontalStackView.center(inView: rectView)
    }
    
    @objc
    private func homeBtnTapped() {
        navigationController?.popToViewController(ChooseScenarioController.self)
    }
    
    @objc
    private func retryBtnTapped() {
        navigationController?.popToViewController(MultipleChoiceViewController.self)
    }
    
    private func createConfettiView() -> SwiftConfettiView {
        let confettiView = SwiftConfettiView(frame: self.view.bounds)
        confettiView.type = .confetti
        confettiView.colors = [.yellowConfetti, .orangeConfetti, .greenConfetti]
        confettiView.intensity = 0.75
        confettiView.startConfetti()
        
        return confettiView
    }
    
    private func setRectView() -> UIView {
        let rectFrame: CGRect = CGRect(x: 0, y: 0, width: ScreenSizeConfiguration.SCREEN_WIDTH/2.68, height: ScreenSizeConfiguration.SCREEN_HEIGHT/4.5)
        let rectView = UIView(frame: rectFrame)
        rectView.backgroundColor = UIColor.yellowRectangleFill
        rectView.layer.cornerRadius = 100
        rectView.layer.shadowColor = UIColor.black.cgColor
        rectView.layer.shadowOpacity = 0.2
        rectView.layer.shadowOffset = CGSize(width: 0, height: 5)
        rectView.layer.shouldRasterize = true
        rectView.layer.borderWidth = 3
        rectView.layer.borderColor = UIColor.yellowRectangleStroke.cgColor
        
        return rectView
    }
}
