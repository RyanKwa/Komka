//
//  WordCollectionViewCell.swift
//  Komka
//
//  Created by Ryan Vieri Kwa on 19/10/22.
//

import UIKit

class WordCollectionViewCell: UICollectionViewCell {
    enum WordState{
        case active
        case idle
    }
    static let identifier = "wordCollectionViewCell"
    var wordTitle: UILabel = UIView.createLabel(text: "Text", fontSize: 20)
    var wordImage: UIImageView = UIView.setImageView(imageName: "ArrangeWord_Idle")
    var wordState: WordState = .idle
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(wordImage)
        wordImage.addSubview(wordTitle)
        setConstraint()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraint(){
        wordImage.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor)
        wordTitle.center(inView: wordImage)
    }
}
