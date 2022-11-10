//
//  ArrangeWordViewController.swift
//  Komka
//
//  Created by Ryan Vieri Kwa on 19/10/22.
//

import UIKit
import CloudKit
import RxCocoa
import RxSwift

class ArrangeWordViewController: ViewController {
    private enum CollectionViewIdentifier {
        case wordSlotCollectionView
        case wordCollectionView
    }
    
    internal var arrangeWordVM = ArrangeWordViewModel()
    
    internal var wordChoices = [String]()
    internal var correctSentencesInOrder = [String]()
    internal var totalCorrectWord = 0
    
    // To store current selected word cell
    internal var scenarioCoverImage, arrangeWordCharacterImage: UIImage?
    
    lazy private var backgroundImg = UIView.createImageView(imageName: "bg")
    lazy private var scenarioCoverImg: UIImageView = {
        let image = UIView.createImageView(image: scenarioCoverImage ?? UIImage(), contentMode: .scaleAspectFill, clipsToBound: true)
        image.addWhiteOverlay()
        
        return image
    }()
    lazy private var scenarioImg = UIView.createImageView(image: arrangeWordCharacterImage ?? UIImage(), contentMode: .scaleAspectFit,clipsToBound: true)
    
    lazy private var promptLabel = UIView.createLabel(text: "Susunlah kata dengan urutan yang benar", fontSize: 40)
        
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
    
    lazy internal var wordCollectionView: UICollectionView = createCollectionView(name: CollectionViewIdentifier.wordCollectionView)
    lazy internal var wordSlotCollectionView: UICollectionView = createCollectionView(name: CollectionViewIdentifier.wordSlotCollectionView)
    internal var selectedWord: UICollectionViewCell?

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        arrangeWordVM.getArrangeWordAssets()
        setUpArrangeWordData()
        subViewConfiguration()
        collectionViewConfiguration()
        setConstraint()
        setupCollectionView()
    }
    
    private func setUpArrangeWordData() {
        scenarioCoverImage = UIImage.changeImageFromURL(baseImage: arrangeWordVM.getArrangeWordAssetPart(.scenarioCover))
        arrangeWordCharacterImage = UIImage.changeImageFromURL(baseImage: arrangeWordVM.getArrangeWordAssetPart(.arrangeWordCharacter))
        correctSentencesInOrder = arrangeWordVM.getSentencesFromScenario()
        wordChoices = correctSentencesInOrder.shuffled()
        wordCollectionView.reloadData()
        wordSlotCollectionView.reloadData()
    }

    private func subViewConfiguration() {
        view.addSubview(backgroundImg)
        view.addSubview(backBtn)
        
        backgroundImg.addSubview(scenarioCoverImg)
        scenarioCoverImg.addSubview(scenarioImg)
        backgroundImg.addSubview(promptLabel)
        view.addSubview(audioBtn)

        view.addSubview(wordSlotCollectionView)
        view.addSubview(wordCollectionView)
    }
    
    private func collectionViewConfiguration(){
        wordSlotCollectionView.backgroundColor = .clear
        wordCollectionView.backgroundColor = .clear
        wordCollectionView.delegate = self
        wordCollectionView.dataSource = self
        
        wordSlotCollectionView.delegate = self
        wordSlotCollectionView.dataSource = self
    }
    
    private func setConstraint() {
        backgroundImg.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        scenarioCoverImg.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingBottom: ScreenSizeConfiguration.SCREEN_HEIGHT/2.2)
        scenarioImg.anchor(bottom: scenarioCoverImg.bottomAnchor)
        scenarioImg.centerX(inView: scenarioCoverImg)
        scenarioImg.setDimensions(width: ScreenSizeConfiguration.SCREEN_WIDTH/2.99, height: ScreenSizeConfiguration.SCREEN_HEIGHT/2.51)
        
        audioBtn.anchor(left: scenarioImg.rightAnchor, bottom: scenarioCoverImg.bottomAnchor, right: scenarioCoverImg.rightAnchor, paddingLeft: -20, paddingBottom: 10, paddingRight: ScreenSizeConfiguration.SCREEN_WIDTH/5)
        
        backBtn.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: ScreenSizeConfiguration.SCREEN_HEIGHT/25, paddingLeft: ScreenSizeConfiguration.SCREEN_WIDTH/30)
        promptLabel.anchor(top:scenarioCoverImg.topAnchor, paddingTop: ScreenSizeConfiguration.SCREEN_HEIGHT/25)
        promptLabel.centerX(inView: view)
    }
    
    private func setupCollectionView() {
        wordSlotCollectionView.anchor(top: scenarioCoverImg.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: ScreenSizeConfiguration.SCREEN_WIDTH/30, paddingLeft: ScreenSizeConfiguration.SCREEN_WIDTH/20, paddingBottom: ScreenSizeConfiguration.SCREEN_HEIGHT/3, paddingRight: ScreenSizeConfiguration.SCREEN_WIDTH/20)
        
        wordCollectionView.anchor(top: wordSlotCollectionView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: ScreenSizeConfiguration.SCREEN_HEIGHT/20, paddingLeft: ScreenSizeConfiguration.SCREEN_WIDTH/20, paddingBottom: ScreenSizeConfiguration.SCREEN_HEIGHT/5, paddingRight: ScreenSizeConfiguration.SCREEN_WIDTH/20)
        
    }
    @objc
    private func audioBtnTapped(_ sender: UIButton) {
        let ttsSentence = String.convertArrayToString(array: correctSentencesInOrder)
        TextToSpeechService.shared.stopSpeech()
        TextToSpeechService.shared.startSpeech([ttsSentence])
    }
    
    @objc
    private func backBtnTapped(_ sender: UIButton) {
        SoundEffectService.shared.playSoundEffect(.Bubble)
        self.navigationController?.popViewController(animated: false)
    }
    
    private func createCollectionView(name: CollectionViewIdentifier) -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: ScreenSizeConfiguration.SCREEN_WIDTH/6, height: ScreenSizeConfiguration.SCREEN_HEIGHT/14)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        if name == .wordSlotCollectionView {
            collectionView.register(WordSlotCollectionViewCell.self, forCellWithReuseIdentifier: WordSlotCollectionViewCell.identifier)
        }
        else if name == .wordCollectionView {
            collectionView.register(WordCollectionViewCell.self, forCellWithReuseIdentifier: WordCollectionViewCell.identifier)
        }
        return collectionView
    }
}
