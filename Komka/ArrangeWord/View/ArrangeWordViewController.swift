//
//  ArrangeWordViewController.swift
//  Komka
//
//  Created by Ryan Vieri Kwa on 19/10/22.
//

import UIKit
import RxCocoa
import RxSwift
class ArrangeWordViewController: UIViewController {
    private enum CollectionViewIdentifier {
        case wordSlotCollectionView
        case wordCollectionView
    }
    var arrangeWordVM = ArrangeWordViewModel()
    private let disposeBag = DisposeBag()
    private var correctSentences = [String]()
    private var wordChoices = [String]()
    //TODO: replace string with passed scenarioID from fetched records
    var scenarioID: String? = "D77FA9FF-B313-69D0-2997-2EBB63A22A93"
    // To store current selected word cell
    private var selectedWord: UICollectionViewCell?
    
    lazy private var backgroundImg = UIView.createImageView(imageName: "bg")
    lazy private var scenarioCoverImg: UIImageView = {
        let image = UIView.createImageView(imageName: "KamarMandiCover", contentMode: .scaleAspectFill, clipsToBound: true)
        image.addWhiteOverlay()
        
        return image
    }()
    lazy private var scenarioImg = UIView.createImageView(imageName: "Mandi", contentMode: .scaleAspectFit,clipsToBound: true)
    
    private lazy var promptLabel = UIView.createLabel(text: "Susunlah kata dengan urutan yang benar", fontSize: 40)
        
    lazy private var audioBtn: UIButton = {
        let button = UIView.createImageIconBtn(title: "", imgTitle: "audioBtn")
        button.addTarget(self, action: #selector(audioBtnTapped), for: .touchUpInside)
        
        return button
    }()
    
    lazy private var backBtn: UIButton = {
        let button = UIView.createImageIconBtn(title: "", imgTitle: "BackBtn")
        button.addTarget(self, action: #selector(backBtnTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var wordCollectionView: UICollectionView = createCollectionView(name: CollectionViewIdentifier.wordCollectionView)
    private lazy var wordSlotCollectionView: UICollectionView = createCollectionView(name: CollectionViewIdentifier.wordSlotCollectionView)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        arrangeWordVM.getSentencesFromScenario(scenarioID: scenarioID ?? "")
        arrangeWordVM.sentences.subscribe(onNext: { [weak self] sentence in
            DispatchQueue.main.async {
                self?.correctSentences = sentence
                self?.wordChoices = self?.correctSentences.shuffled() ?? []
                self?.wordCollectionView.reloadData()
                self?.wordSlotCollectionView.reloadData()
            }
        }, onError: { error in
            let errorMessage = error as? FetchError
            print("Error: \(errorMessage?.localizedDescription)")
        }, onCompleted: {
            
        })
        .disposed(by: disposeBag)
        subViewConfiguration()
        collectionViewConfiguration()
        setConstraint()
    }

    func subViewConfiguration() {
        view.backgroundColor = .white
        view.addSubview(backgroundImg)
        backgroundImg.addSubview(scenarioCoverImg)
        scenarioCoverImg.addSubview(scenarioImg)
        view.addSubview(audioBtn)
        view.addSubview(backBtn)
        backgroundImg.addSubview(promptLabel)
        
        view.addSubview(wordSlotCollectionView)
        view.addSubview(wordCollectionView)
    }
    
    func collectionViewConfiguration(){
        wordSlotCollectionView.backgroundColor = .clear
        wordCollectionView.backgroundColor = .clear
        wordCollectionView.delegate = self
        wordCollectionView.dataSource = self
        
        wordSlotCollectionView.delegate = self
        wordSlotCollectionView.dataSource = self
        
    }
    func setConstraint() {
        backgroundImg.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        scenarioCoverImg.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingBottom: ScreenSizeConfiguration.SCREEN_HEIGHT/2.2)
        scenarioImg.anchor(top: scenarioCoverImg.topAnchor, left: scenarioCoverImg.leftAnchor, bottom: scenarioCoverImg.bottomAnchor, right: scenarioCoverImg.rightAnchor,paddingTop: ScreenSizeConfiguration.SCREEN_HEIGHT/10,paddingLeft: ScreenSizeConfiguration.SCREEN_WIDTH/3, paddingRight: ScreenSizeConfiguration.SCREEN_WIDTH/3)
        
        backBtn.anchor(top: scenarioCoverImg.topAnchor, left: scenarioCoverImg.leftAnchor, paddingTop: ScreenSizeConfiguration.SCREEN_HEIGHT/25, paddingLeft: ScreenSizeConfiguration.SCREEN_WIDTH/30)
        audioBtn.anchor(top: scenarioCoverImg.topAnchor, left: scenarioImg.rightAnchor, bottom: scenarioCoverImg.bottomAnchor, right: scenarioCoverImg.rightAnchor, paddingTop: (ScreenSizeConfiguration.SCREEN_HEIGHT/2.2), paddingLeft: -20, paddingRight: ScreenSizeConfiguration.SCREEN_WIDTH/5)
        
        promptLabel.anchor(top:scenarioCoverImg.topAnchor, left: backBtn.rightAnchor, paddingTop: ScreenSizeConfiguration.SCREEN_HEIGHT/25)
        promptLabel.centerX(inView: view)
        
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        wordSlotCollectionView.anchor(top: scenarioCoverImg.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: ScreenSizeConfiguration.SCREEN_WIDTH/30, paddingLeft: ScreenSizeConfiguration.SCREEN_WIDTH/20, paddingBottom: ScreenSizeConfiguration.SCREEN_HEIGHT/3, paddingRight: ScreenSizeConfiguration.SCREEN_WIDTH/20)
        
        wordCollectionView.anchor(top: wordSlotCollectionView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: ScreenSizeConfiguration.SCREEN_HEIGHT/20, paddingLeft: ScreenSizeConfiguration.SCREEN_WIDTH/20, paddingBottom: ScreenSizeConfiguration.SCREEN_HEIGHT/5, paddingRight: ScreenSizeConfiguration.SCREEN_WIDTH/20)
        
    }
    @objc
    private func audioBtnTapped(_ sender: UIButton) {
        TextToSpeechService.shared.stopSpeech()
        TextToSpeechService.shared.startSpeech(correctSentences)
    }
    
    @objc
    private func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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

extension ArrangeWordViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wordChoices.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.wordSlotCollectionView {
            guard let wordSlotCell = collectionView.dequeueReusableCell(withReuseIdentifier: WordSlotCollectionViewCell.identifier, for: indexPath) as? WordSlotCollectionViewCell else {
                return UICollectionViewCell()
            }
            wordSlotCell.answerImage.alpha = 0
            wordSlotCell.slotImage.image = UIImage(named: "WordSlot")
            return wordSlotCell
        }
        else {
            guard let wordCell = collectionView.dequeueReusableCell(withReuseIdentifier: WordCollectionViewCell.identifier, for: indexPath) as? WordCollectionViewCell else {
                return UICollectionViewCell()
            }
            wordCell.wordTitle.text = wordChoices[indexPath.row]
            wordCell.wordImage.image = UIImage(named: "ArrangeWord_Idle")
            return wordCell
        }
    }
    
    //MARK: Word Arrangement Logic
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.wordSlotCollectionView {
            let cell = collectionView.cellForItem(at: indexPath) as? WordSlotCollectionViewCell
            
            guard let currentSelectedWordCell = selectedWord as? WordCollectionViewCell, let selectedSlot = cell else {
                return
            }
            
            let isWordPlacementCorrect = arrangeWordVM.evaluateWordPlacement(selectedWord: currentSelectedWordCell.wordTitle.text ?? "", placementIndex: indexPath.row, sentences: correctSentences)
            
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
                currentSelectedWordCell.alpha = 0
                selectedSlot.answerImage.alpha = 1
                selectedSlot.wordTitle.text = currentSelectedWordCell.wordTitle.text
                self?.showResultBorder(slotCell: selectedSlot, wordCell: currentSelectedWordCell, withResult: isWordPlacementCorrect)
            })
        }
        else if collectionView == self.wordCollectionView {
            
            let currentSelectedWordCell = collectionView.cellForItem(at: indexPath) as? WordCollectionViewCell
            
            if currentSelectedWordCell?.state == .idle{
                self.setCellState(cell: currentSelectedWordCell ?? WordCollectionViewCell(), state: .active)
                
                //Check wether there is selected word or not
                if self.selectedWord != nil {
                    let previousActiveCell = self.selectedWord as? WordCollectionViewCell
                    self.setCellState(cell: previousActiveCell ?? WordCollectionViewCell(), state: .idle)
                }
                
                self.selectedWord = currentSelectedWordCell
            }
            
            else if currentSelectedWordCell?.state == .active{
                setCellState(cell: currentSelectedWordCell ?? WordCollectionViewCell(), state: .idle)
                self.selectedWord = nil
            }
        }
    }
    
    private func setCellState(cell: WordCollectionViewCell, state: WordCollectionViewCell.State) {
        UIView.transition(with: cell, duration: 0.2, options: .transitionCrossDissolve, animations: {
            if state == .idle {
                cell.wordImage.image = UIImage(named: "ArrangeWord_Idle")
            }
            else{
                cell.wordImage.image = UIImage(named: "ArrangeWord_Active")
            }
            cell.state = state
        })
    }

    private func showResultBorder(slotCell: WordSlotCollectionViewCell, wordCell: WordCollectionViewCell, withResult isCorrect: Bool) {
        if isCorrect {
            setCellBorderColor(cell: slotCell, color: UIColor.correctWordPlacementBorderColor)
            slotCell.answerImage.layer.borderWidth = 6
            slotCell.slotImage.alpha = 0
            slotCell.slotImage.isHidden = true
            slotCell.isUserInteractionEnabled = false
        }
        else{
            setCellBorderColor(cell: slotCell, color: UIColor.wrongWordPlacementBorderColor)
            slotCell.answerImage.layer.borderWidth = 4
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                UIView.transition(with: slotCell, duration: 0.5, options: .transitionCrossDissolve, animations: { [weak self] in
                    slotCell.answerImage.alpha = 0
                    slotCell.answerImage.layer.borderColor = CGColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 0.00)
                    slotCell.answerImage.layer.borderWidth = 0

                    self?.setCellState(cell: wordCell, state: .idle)
                })
                UIView.animate(withDuration: 0.5, delay: 0.5) {
                    wordCell.alpha = 1
                }
            }
            selectedWord = nil
        }
    }
    
    private func setCellBorderColor(cell: WordSlotCollectionViewCell, color: UIColor) {
        cell.answerImage.layer.borderColor  = color.cgColor
        cell.answerImage.layer.cornerRadius = 26
    }
    
    //MARK: Align Center collection view cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let totalWords = CGFloat(wordChoices.count)
        if totalWords == 0{
            return UIEdgeInsets.zero
        }
        guard let collectionFlowLayout = collectionViewLayout as? UICollectionViewFlowLayout else{
            return UIEdgeInsets.zero
        }
        let cellWidth = collectionFlowLayout.itemSize.width + collectionFlowLayout.minimumInteritemSpacing
        
        let totalCellWidth = (cellWidth * totalWords) + 10.0 + (totalWords-1)
        let contentWidth = collectionView.frame.size.width - collectionView.contentInset.left - collectionView.contentInset.right
        
        if totalCellWidth < contentWidth {
            let padding = (contentWidth - totalCellWidth) / 2
            return UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
        }
        else{
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
}

