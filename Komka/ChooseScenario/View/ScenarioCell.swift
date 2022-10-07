//
//  ScenarioCell.swift
//  Komka
//
//  Created by Evelin Evelin on 04/10/22.
//

import UIKit

class ScenarioCell: UICollectionViewCell {
    
    static let identifier = "scenarioCollectionViewCell"
    
    private lazy var scenarioImg: UIImageView = {
       let img = UIImageView()
        img.contentMode = .scaleToFill
        img.image = #imageLiteral(resourceName: "RuangMakanCover")
        
        img.translatesAutoresizingMaskIntoConstraints = false

        return img
    }()
    
    private lazy var scenarioLbl: UILabel = {
       let lbl = UILabel()
        lbl.text = "Scenario Name"
        lbl.font = UIFont.balooFont(size: 30)
        lbl.textAlignment = .center

        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        return lbl
    }()
    
    private lazy var stackViewScenario: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [scenarioImg, scenarioLbl])
        stackView.axis = .vertical
        stackView.spacing = 5
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private func setConstraint(){
        NSLayoutConstraint.activate([
            scenarioImg.bottomAnchor.constraint(equalTo: stackViewScenario.bottomAnchor, constant: -50),

            stackViewScenario.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackViewScenario.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            stackViewScenario.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            stackViewScenario.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

        ])
    }
    
    private func addViews(){
        contentView.addSubview(stackViewScenario)
        setConstraint()
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
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = true
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 1.5
        layer.shadowOpacity = 0.5
        
        ovalShadow()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        cellStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
