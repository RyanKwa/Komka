//
//  ScenarioCell.swift
//  Komka
//
//  Created by Evelin Evelin on 04/10/22.
//

import UIKit
import CloudKit

class ScenarioCell: UICollectionViewCell {
    
    static let identifier = "scenarioCollectionViewCell"
    
    
    lazy var scenarioImg = UIView.createImageView(imageName: "Scenario Img")
    lazy var scenarioLabel = UIView.createLabel(text: "Scenario Name", fontSize: 30)
        
    private func setConstraint(){

        scenarioImg.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingBottom: contentView.frame.height/4)
    
        scenarioLabel.centerX(inView: contentView)
        scenarioLabel.anchor(bottom: contentView.bottomAnchor, paddingBottom: contentView.frame.height/13)
    }
    
    private func ovalShadow() {
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: 0, y: contentView.frame.height - contentView.frame.height/10, width: contentView.frame.width, height: contentView.frame.height/5)).cgPath
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = ovalPath
        shapeLayer.fillColor = UIColor.gray.cgColor
        shapeLayer.strokeColor = UIColor.gray.cgColor
        shapeLayer.lineWidth = 5.0
        shapeLayer.opacity = 0.2
        
        self.layer.insertSublayer(shapeLayer, below: contentView.layer)
    }
    
    private func cellStyle(){
        scenarioLabel.textAlignment = .center

        contentView.backgroundColor = .white

        contentView.layer.cornerRadius = 40
        contentView.layer.masksToBounds = true
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 1.5
        layer.shadowOpacity = 0.5
        
        ovalShadow()
    }
    
    func addLockOverlay(isHidden: Bool){
        let overlay: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        let lockImage = UIView.createImageView(imageName: "Lock.png")

        overlay.backgroundColor = UIColor(white: 0, alpha: 0.7)
        overlay.clipsToBounds = true

        if (!isHidden) {
            overlay.tag = 1
            if contentView.viewWithTag(1) == nil {
                contentView.addSubview(overlay)
                contentView.addSubview(lockImage)
                lockImage.center(inView: contentView)
            }
        }
        else {
            if contentView.viewWithTag(1) != nil{
                contentView.subviews[2].removeFromSuperview()
                contentView.subviews[2].removeFromSuperview()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(scenarioImg)
        contentView.addSubview(scenarioLabel)
        setConstraint()
        cellStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
