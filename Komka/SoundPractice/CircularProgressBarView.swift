//
//  CircularProgressBar.swift
//  Komka
//
//  Created by Evelin Evelin on 17/10/22.
//

import UIKit

class CircularProgressBarView: UIView {
    
    var currentWordBg: String?
    var currentWordImg: String?
    var currentWordLabel: String?
    
    var duration: TimeInterval?
    
    init(frame: CGRect, currentWordLabel: String) {
        super.init(frame: frame)
        self.currentWordLabel = currentWordLabel
        createCircleProgressBar()
        setConstraintImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var circleShape = CAShapeLayer()
    private lazy var progressLayer = CAShapeLayer()
    private lazy var maskLayer = CAShapeLayer()

    private lazy var startPoint = CGFloat(-Double.pi/2)
    private lazy var endPoint = CGFloat(3 * Double.pi/2)
    
    private lazy var scenarioBG: UIImageView = {
        let image = UIView.createImageView(imageName: currentWordBg ?? "KamarMandiCover", clipsToBound: true)

        image.addWhiteOverlay()
        
        return image
    }()
    
    private lazy var scenarioImg: UIImageView = {
        let wordActImage = UIView.createImageView(imageName: (currentWordImg ?? "BadanSayaKotor"), contentMode: .scaleAspectFit, clipsToBound: true)
        
        return wordActImage
    }()
    
    func createCircleShape(circlePath: UIBezierPath){
        circleShape.path = circlePath.cgPath
        circleShape.fillColor = UIColor.clear.cgColor
        circleShape.lineWidth = 40
        circleShape.strokeEnd = 100
        circleShape.strokeColor = UIColor.lightGray.cgColor
        scenarioBG.layer.mask = circleShape
        setLayerPosition(shape: circleShape)
    }
    
    func createProgressLayer(circlePath: UIBezierPath){
        progressLayer.path = circlePath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineWidth = 40.0
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = 0
        progressLayer.strokeColor = UIColor.orange.cgColor
        setLayerPosition(shape: progressLayer)
    }
    
    func createMask(circlePath: UIBezierPath){
        maskLayer.path = circlePath.cgPath
        maskLayer.fillColor = UIColor.black.cgColor
        maskLayer.lineWidth = 40
        maskLayer.strokeColor = UIColor.lightGray.cgColor
        scenarioBG.layer.mask = maskLayer
        setLayerPosition(shape: maskLayer)
    }

    func createCircleProgressBar(){
        let circlePath = UIBezierPath(arcCenter: center, radius: ScreenSizeConfiguration.SCREEN_WIDTH/5, startAngle: startPoint, endAngle: endPoint, clockwise: true)
                
        createCircleShape(circlePath: circlePath)
        createProgressLayer(circlePath: circlePath)
        createMask(circlePath: circlePath)
        
        scenarioBG.layer.addSublayer(circleShape)
        scenarioBG.layer.addSublayer(progressLayer)
        scenarioBG.addSubview(scenarioImg)
        addSubview(scenarioBG)
    }
    
    func setLayerPosition(shape: CAShapeLayer){
        shape.position = CGPoint(x: (scenarioBG.frame.midX - scenarioBG.frame.midX/2), y: (scenarioBG.frame.midY - scenarioBG.frame.midY/3))
    }
    
    func setConstraintImage(){
        scenarioBG.setDimensions(width: ScreenSizeConfiguration.SCREEN_WIDTH/2, height: ScreenSizeConfiguration.SCREEN_HEIGHT/1.5)
        scenarioBG.center(inView: self)
        
        scenarioImg.setDimensions(width: scenarioBG.frame.width/2.5, height: scenarioBG.frame.height/2.5)
        scenarioImg.center(inView: scenarioBG)
    }
    
    func progressAnimation(progressFrom: CGFloat, progressTo: CGFloat) {
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        circularProgressAnimation.fromValue = progressFrom
        circularProgressAnimation.toValue = progressTo
        circularProgressAnimation.duration = duration ?? 0
        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = false

        progressLayer.add(circularProgressAnimation, forKey: "progressAnimate")
    }
}

