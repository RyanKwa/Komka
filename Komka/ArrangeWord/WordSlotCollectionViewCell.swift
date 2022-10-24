//
//  WordSlotCollectionViewCell.swift
//  Komka
//
//  Created by Ryan Vieri Kwa on 19/10/22.
//

import UIKit

class WordSlotCollectionViewCell: UICollectionViewCell {
    static let identifier = "wordSlotCollectionViewCell"
    var wordTitle: UILabel = UIView.createLabel(text: "Text", fontSize: 20)
    var slotImage: UIImageView = UIView.setImageView(imageName: "WordSlot")
    var answerImage: UIImageView = UIView.setImageView(imageName: "ArrangeWord_Active")
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(slotImage)
        contentView.addSubview(answerImage)
        answerImage.addSubview(wordTitle)

        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setConstraint(){
        slotImage.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor)
        answerImage.anchor(top: slotImage.topAnchor, left: slotImage.leftAnchor, bottom: slotImage.bottomAnchor, right: slotImage.rightAnchor)
        wordTitle.center(inView: answerImage)
    }

}
