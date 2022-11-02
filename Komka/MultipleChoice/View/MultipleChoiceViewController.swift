//
//  MultipleChoiceViewController.swift
//  Komka
//
//  Created by Ryan Vieri Kwa on 12/10/22.
//

import UIKit
import CloudKit
import RxSwift

class MultipleChoiceViewController: UIViewController {
    
    private var scenarioRecordId: CKRecord.ID
    
    private var multipleChoiceVM: MultipleChoiceViewModel
    private var multipleChoice: MultipleChoice?
    
    private var scenarioCoverImage, multipleChoiceCharacterImage: UIImage?
    private var leftChoiceImage, rightChoiceImage: UIImage?
    private var wrongChoiceImage, correctChoiceImage: UIImage?
    
    private var timer: Timer?
    private var timerCounter = 2
    
    init(scenarioRecordId: CKRecord.ID) {
        self.scenarioRecordId = scenarioRecordId
        self.multipleChoiceVM = MultipleChoiceViewModel(scenarioRecordId: scenarioRecordId)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var backBtn: UIButton = {
        let button = UIView.createImageIconBtn(imgTitle: "BackBtn")
        button.addTarget(self, action: #selector(backBtnTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var backgroundImage = UIView.createImageView(imageName: "bg")
    
    private lazy var scenarioCoverImg: UIImageView = {
        let image = UIView.createImageView(image: scenarioCoverImage ?? UIImage(), contentMode: .scaleAspectFill, clipsToBound: true)
        image.addWhiteOverlay()
        return image
    }()

    private lazy var imageScenario = UIView.createImageView(image: multipleChoiceCharacterImage ?? UIImage(), contentMode: .scaleAspectFit, clipsToBound: true)
    
    private lazy var promptLabel: UILabel = {
        let label = UIView.createLabel(text: "Apa yang harus saya lakukan?", fontSize: 40)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var leftChoice: UIImageView = {
        let imageView = UIView.createImageView(image: leftChoiceImage ?? UIImage(), contentMode: .scaleAspectFit, clipsToBound: true)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(choiceTapped))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        imageView.tag = 0
        
        return imageView
    }()
    
    private lazy var rightChoice: UIImageView = {
        let imageView = UIView.createImageView(image: rightChoiceImage ?? UIImage(), contentMode: .scaleAspectFit, clipsToBound: true)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(choiceTapped))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        imageView.tag = 1
        
        return imageView
    }()
 
    private lazy var audioBtn: UIButton = {
        let button = UIView.createImageIconBtn(imgTitle: "audioBtn")
        button.addTarget(self, action: #selector(audioBtnTapped), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        configureSubView()
    }
    
    private func configureSubView(){
        view.addSubview(backgroundImage)
        view.addSubview(backBtn)
        backBtn.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: ScreenSizeConfiguration.SCREEN_HEIGHT/25, paddingLeft: ScreenSizeConfiguration.SCREEN_WIDTH/30)
        
        multipleChoiceVM.publishMultipleChoiceAssets.subscribe(onNext: { _ in
            DispatchQueue.main.async { [self] in
                scenarioCoverImage = multipleChoiceVM.getMultipleChoiceAssetPart(.scenarioCover)
                multipleChoiceCharacterImage = multipleChoiceVM.getMultipleChoiceAssetPart(.multipleChoiceCharacter)
                leftChoiceImage = multipleChoiceVM.getMultipleChoiceAssetPart(.leftChoice)
                rightChoiceImage = multipleChoiceVM.getMultipleChoiceAssetPart(.rightChoice)
                
                view.addSubview(audioBtn)
                backgroundImage.addSubview(scenarioCoverImg)
                scenarioCoverImg.addSubview(self.imageScenario)
                backgroundImage.addSubview(promptLabel)
                view.addSubview(leftChoice)
                view.addSubview(rightChoice)
                
                backgroundImage.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
                scenarioCoverImg.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingBottom: ScreenSizeConfiguration.SCREEN_HEIGHT/2.2)
                
                imageScenario.anchor(top: scenarioCoverImg.topAnchor, left: scenarioCoverImg.leftAnchor, bottom: scenarioCoverImg.bottomAnchor, right: scenarioCoverImg.rightAnchor,paddingTop: ScreenSizeConfiguration.SCREEN_HEIGHT/10,paddingLeft: ScreenSizeConfiguration.SCREEN_WIDTH/3, paddingRight: ScreenSizeConfiguration.SCREEN_WIDTH/3)
                audioBtn.anchor(top: scenarioCoverImg.topAnchor, left: imageScenario.rightAnchor, bottom: scenarioCoverImg.bottomAnchor, right: scenarioCoverImg.rightAnchor, paddingTop: (ScreenSizeConfiguration.SCREEN_HEIGHT/2.2), paddingLeft: -20, paddingRight: ScreenSizeConfiguration.SCREEN_WIDTH/5)
                
                promptLabel.anchor(top:scenarioCoverImg.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingBottom: ScreenSizeConfiguration.SCREEN_HEIGHT/3)
                
                leftChoice.anchor(top:promptLabel.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingRight: ScreenSizeConfiguration.SCREEN_WIDTH/2)
                rightChoice.anchor(top:promptLabel.bottomAnchor, left: leftChoice.rightAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
            }
        })
        .disposed(by: multipleChoiceVM.disposeBag)
    }
    
    @objc
    private func audioBtnTapped(_ sender: UIButton) {
        multipleChoiceVM.playTextToSpeech()
    }
    
    @objc
    private func backBtnTapped(_ sender: UIButton) {
        SoundEffectService.shared.playSoundEffect(.Bubble)
        self.navigationController?.popViewController(animated: false)
    }
    
    @objc
    private func choiceTapped(_ sender: UITapGestureRecognizer){
        let isCorrectAnswer: Bool
        
        if sender.view?.tag == 0 {
            isCorrectAnswer = multipleChoiceVM.isCorrectAnswer(choice: Choices.leftChoice)
            updateChoiceState(choice: leftChoice, isCorrectAnswer: isCorrectAnswer)
            
        } else if sender.view?.tag == 1 {
            isCorrectAnswer = multipleChoiceVM.isCorrectAnswer(choice: Choices.rightChoice)
            updateChoiceState(choice: rightChoice, isCorrectAnswer: isCorrectAnswer)
        }
    }
    
    private func updateChoiceState(choice: UIImageView, isCorrectAnswer: Bool) {
        if isCorrectAnswer {
            SoundEffectService.shared.playSoundEffect(.Correct)
            choice.image = self.multipleChoiceVM.getMultipleChoiceAssetPart(.correctChoice)
        } else {
            SoundEffectService.shared.playSoundEffect(.Incorrect)
            choice.image = self.multipleChoiceVM.getMultipleChoiceAssetPart(.wrongChoice)
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [self] timer in
            timerCounter -= 1
            if timerCounter <= 0 {
                if isCorrectAnswer {
                    navigationController?.pushViewController(FullSentencesViewController(), animated: false)
                }
                
                if choice == leftChoice {
                    choice.image = leftChoiceImage
                } else if choice == rightChoice {
                    choice.image = rightChoiceImage
                }
                
                timerCounter = 2
                timer.invalidate()
            }
        }
    }
}
