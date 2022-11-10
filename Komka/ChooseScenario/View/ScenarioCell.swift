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
    
    private lazy var stackViewScenario = UIView.createStackView(arrangedSubviews: [scenarioImg, scenarioLabel], axis: .vertical, spacing: 25)
    
    private func setConstraint(){
        stackViewScenario.anchor(top: contentView.topAnchor)
        stackViewScenario.anchor(left: contentView.leftAnchor)
        stackViewScenario.anchor(right: contentView.rightAnchor)
        stackViewScenario.anchor(bottom: contentView.bottomAnchor)
        
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(stackViewScenario)
        setConstraint()
        cellStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
