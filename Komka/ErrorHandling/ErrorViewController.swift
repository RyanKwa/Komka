//
//  ErrorViewController.swift
//  Komka
//
//  Created by Ryan Vieri Kwa on 16/11/22.
//

import UIKit

protocol ErrorViewDelegate: AnyObject {
    func closeBtnTapped()
    func cobaLagiBtnTapped()
}

class ErrorViewController: ViewController {
    
    weak var delegate: ErrorViewDelegate?
    
    var errorTitleMessage: String?
    var errorDescription: String?
    var errorGuidance: String?

    private lazy var errorTitleLabel = UIView.createLabel(text: errorTitleMessage ?? "This is error title", fontSize: 35)
    
    private lazy var errorDescriptionLabel = UIView.createLabel(text: errorDescription ?? "This is error description", fontSize: 24)
    
    private lazy var errorGuidanceLabel = UIView.createLabel(text: errorGuidance ?? "This is error guidance", fontSize: 24)
    
    private var closeBtn: UIButton = {
        let button = UIView.createImageIconBtn(imgTitle: "CloseButton")
        button.addTarget(self, action: #selector(closeBtnTapped), for: .touchUpInside)
        return button
    }()
    
    private var cobaLagiBtn: UIButton = {
        let button = LevelButton()
        button.configure(with: LevelButtonVM(title: "Coba Lagi", image: "LanjutMulaiBtn", size: 30))
        button.addTarget(self, action: #selector(cobaLagiBtnTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var alertView: UIView = {
        let alertView = UIView()
        alertView.frame = CGRect(x: 0, y: 0, width: ScreenSizeConfiguration.SCREEN_WIDTH/2, height: ScreenSizeConfiguration.SCREEN_HEIGHT/2.5)
        return alertView
    }()
    private lazy var overlay: UIView = {
        let overlay = UIView()
        overlay.backgroundColor = .black.withAlphaComponent(0.2)
        return overlay
    }()
    private lazy var backgroundImage = UIView.createImageView(imageName: "bg")
    
    private var alertViewWidth = 0.0
    private var alertViewHeight = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        alertViewWidth = alertView.bounds.size.width
        alertViewHeight = alertView.bounds.size.height
        setupSubview()
    }
    
    private func setupSubview() {
        setupBackgroundImage()
        setupOverlay()
        setupAlertView()
        setupErrorTitle()
        setupCloseBtn()
        setupErrorDescription()
        setupErrorGuidance()
        setupCobaLagiBtn()
    }
    
    private func setupBackgroundImage() {
        view.addSubview(backgroundImage)
        backgroundImage.anchor(top: view.topAnchor,
                               left: view.leftAnchor,
                               bottom: view.bottomAnchor,
                               right: view.rightAnchor)
    }
    
    private func setupOverlay(){
        backgroundImage.addSubview(overlay)
        overlay.anchor(top: backgroundImage.topAnchor,
                       left: backgroundImage.leftAnchor,
                       bottom: backgroundImage.bottomAnchor,
                       right: backgroundImage.rightAnchor)
    }
    
    private func setupAlertView(){
        view.addSubview(alertView)
        alertView.backgroundColor = UIColor.alertViewBackground
        alertView.layer.cornerRadius = 30.0
        alertView.setDimensions(width: alertViewWidth, height: alertViewHeight)

        alertView.center(inView: view)
    }
    
    private func setupCobaLagiBtn() {
        alertView.addSubview(cobaLagiBtn)
        cobaLagiBtn.anchor(bottom: alertView.bottomAnchor,
                           paddingBottom: alertView.bounds.size.height/11)
        cobaLagiBtn.centerX(inView: alertView)
    }
    
    private func setupCloseBtn() {
        alertView.addSubview(closeBtn)
        //TODO: Adjust size according to figma
        closeBtn.anchor(top: alertView.topAnchor,
                        left: errorTitleLabel.rightAnchor,
                        right: alertView.rightAnchor,
                        paddingTop: alertView.bounds.size.height/15,
                        paddingLeft: alertView.bounds.size.width/25,
                        paddingRight: alertView.bounds.size.width/25)
    }
    
    private func setupErrorTitle() {
        alertView.addSubview(errorTitleLabel)
        //TODO: Adjust size according to figma
        errorTitleLabel.anchor(top: alertView.topAnchor,
                               paddingTop: alertView.bounds.size.height/13)
        errorTitleLabel.centerX(inView: alertView)
    }
    
    private func setupErrorDescription() {
        alertView.addSubview(errorDescriptionLabel)
        errorDescriptionLabel.anchor(top: alertView.topAnchor,
                                     paddingTop: alertView.bounds.size.height/3.1)
        errorDescriptionLabel.centerX(inView: alertView)
    }
    
    private func setupErrorGuidance() {
        alertView.addSubview(errorGuidanceLabel)
        errorGuidanceLabel.anchor(top: alertView.topAnchor,
                                  paddingTop: alertView.bounds.size.height/2.3)
        errorGuidanceLabel.centerX(inView: alertView)
    }
    
    @objc
    private func closeBtnTapped(_ sender: UIButton) {
        self.delegate?.closeBtnTapped()
    }
    
    @objc
    private func cobaLagiBtnTapped(_ sender: UIButton) {
        self.delegate?.cobaLagiBtnTapped()
    }
}
