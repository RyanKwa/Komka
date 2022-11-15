//
//  ArrangeWordViewController+Ext.swift
//  Komka
//
//  Created by Ryan Vieri Kwa on 09/11/22.
//

import Foundation
import UIKit

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
            wordCell.wordTitle.addCharacterSpacing()
            wordCell.wordImage.image = UIImage(named: "ArrangeWord_Idle")
            return wordCell
        }
    }
    
    //MARK: Word Arrangement Logic
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        SoundEffectService.shared.playSoundEffect(.Bubble)
        if collectionView == self.wordSlotCollectionView {
            let cell = collectionView.cellForItem(at: indexPath) as? WordSlotCollectionViewCell
            
            guard let currentSelectedWordCell = selectedWord as? WordCollectionViewCell, let selectedSlot = cell else {
                return
            }
            
            let isWordPlacementCorrect = arrangeWordVM.evaluateWordPlacement(selectedWord: currentSelectedWordCell.wordTitle.text ?? "", placementIndex: indexPath.row, sentences: correctSentencesInOrder)
            
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
                currentSelectedWordCell.alpha = 0
                selectedSlot.answerImage.alpha = 1
                selectedSlot.wordTitle.text = currentSelectedWordCell.wordTitle.text
                self?.showResultBorder(slotCell: selectedSlot, wordCell: currentSelectedWordCell, withResult: isWordPlacementCorrect)
            })
            if totalCorrectWord == correctSentencesInOrder.count {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.arrangeWordVM.stopTextToSpeech()
                    self.navigationController?.pushViewController(CompletionPageViewController(), animated: false)
                }
            }
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
            totalCorrectWord += 1
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
