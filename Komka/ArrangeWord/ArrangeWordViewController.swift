//
//  ArrangeWordViewController.swift
//  Komka
//
//  Created by Ryan Vieri Kwa on 19/10/22.
//

import UIKit

class ArrangeWordViewController: UIViewController {

    var numberOfWord = 0
    
    private var selectedCell: UICollectionViewCell?
    
    lazy private var backgroundImg = UIView.setImageView(imageName: "bg")
    lazy private var scenarioCoverImg: UIImageView = {
        let image = UIView.setImageView(imageName: "KamarMandiCover", contentMode: .scaleAspectFill, clipsToBound: true)
        image.addWhiteOverlay()
        
        return image
    }()
    lazy private var scenarioImg = UIView.setImageView(imageName: "Mandi", contentMode: .scaleAspectFit,clipsToBound: true)
    
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

    private lazy var wordCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: ScreenSizeConfiguration.SCREEN_WIDTH/6, height: ScreenSizeConfiguration.SCREEN_HEIGHT/14)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        collectionView.register(WordCollectionViewCell.self, forCellWithReuseIdentifier: WordCollectionViewCell.identifier)
        return collectionView
    }()
    private lazy var wordSlotCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: ScreenSizeConfiguration.SCREEN_WIDTH/6, height: ScreenSizeConfiguration.SCREEN_HEIGHT/14)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        collectionView.register(WordSlotCollectionViewCell.self, forCellWithReuseIdentifier: WordSlotCollectionViewCell.identifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        print("doSomething")
    }
    
    @objc
    private func backBtnTapped(_ sender: UIButton) {
        print("doSomethingAudio")
    }
}

extension ArrangeWordViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfWord
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.wordSlotCollectionView {
            guard let wordSlotCell = collectionView.dequeueReusableCell(withReuseIdentifier: WordSlotCollectionViewCell.identifier, for: indexPath) as? WordSlotCollectionViewCell else {
                return UICollectionViewCell()
            }
            wordSlotCell.wordTitle.text = "Word \(indexPath.row)"
            wordSlotCell.showAnswer = false
            wordSlotCell.answerImage.alpha = 0
//            wordSlotCell.answerImage.isHidden = true
            wordSlotCell.isCorrect = false
            wordSlotCell.slotImage.image = UIImage(named: "WordSlot")
            return wordSlotCell
        }
        else {
            guard let wordCell = collectionView.dequeueReusableCell(withReuseIdentifier: WordCollectionViewCell.identifier, for: indexPath) as? WordCollectionViewCell else {
                return UICollectionViewCell()
            }
            wordCell.wordTitle.text = "Word \(indexPath.row)"
            wordCell.wordImage.image = UIImage(named: "ArrangeWord_Idle")
            return wordCell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.wordSlotCollectionView {
            let cell = collectionView.cellForItem(at: indexPath) as? WordSlotCollectionViewCell
            print("Selected slot index: \(indexPath.row)")
            let correct = false
            guard let currentWord = selectedCell as? WordCollectionViewCell, let currentSlot = cell else {
                return
            }
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) { [weak self] in
                currentWord.alpha = 0
            }
            
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                currentSlot.answerImage.alpha = 1
                currentSlot.showAnswer = true
                currentSlot.wordTitle.text = currentWord.wordTitle.text
                if correct {
                    //green
                    currentSlot.answerImage.layer.borderColor = CGColor(red: 0.56, green: 0.66, blue: 0.34, alpha: 1.00)
                    currentSlot.answerImage.layer.borderWidth = 2
                    currentSlot.isUserInteractionEnabled = false
                }
                else{
                    //red
                    currentSlot.answerImage.layer.borderColor = CGColor(red: 0.62, green: 0.02, blue: 0.02, alpha: 1.00)
                    currentSlot.answerImage.layer.borderWidth = 2
                }
            })
            //if wrong
            if correct == false {

                DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                    UIView.transition(with: currentSlot ?? UICollectionViewCell(), duration: 0.5, options: .transitionCrossDissolve, animations: {
                        currentSlot.answerImage.alpha = 0
                        currentSlot.answerImage.layer.borderColor = CGColor(red: 0.62, green: 0.02, blue: 0.02, alpha: 0.00)
                        currentSlot.answerImage.layer.borderWidth = 0
                        currentWord.wordState = .idle
                        currentWord.wordImage.image = UIImage(named: "ArrangeWord_Idle")
                    })
                    UIView.animate(withDuration: 0.5, delay: 0.5) {
                        currentWord.alpha = 1
                        currentSlot.showAnswer = false
                    }
                }
                selectedCell = nil
            }
        }
        else if collectionView == self.wordCollectionView {
            let cell = collectionView.cellForItem(at: indexPath) as? WordCollectionViewCell
            print("Selected word index: \(indexPath.row)")
            if cell?.wordState == .idle{
                UIView.transition(with: cell ?? UICollectionViewCell(), duration: 0.5, options: .transitionCrossDissolve, animations: {
                    cell?.wordImage.image = UIImage(named: "ArrangeWord_Active")
                    cell?.wordState = .active
                })
                if self.selectedCell != nil {
                    UIView.transition(with: cell ?? UICollectionViewCell(), duration: 1, options: .transitionCrossDissolve, animations: { [weak self] in
                        let previousActiveCell = self?.selectedCell as? WordCollectionViewCell
                        previousActiveCell?.wordImage.image = UIImage(named: "ArrangeWord_Idle")
                        previousActiveCell?.wordState = .idle
                    })
                }
                print("INDEX: \(indexPath.row): \(cell?.wordState)")
                selectedCell = cell
            }
            else if cell?.wordState == .active{
                UIView.transition(with: cell ?? UICollectionViewCell(), duration: 0.5, options: .transitionCrossDissolve, animations: {
                    cell?.wordImage.image = UIImage(named: "ArrangeWord_Idle")
                    cell?.wordState = .idle
                })
                print("INDEX: \(indexPath.row): \(cell?.wordState)")
                selectedCell = nil
            }
        
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        
        let totalWords = CGFloat(numberOfWord)
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

