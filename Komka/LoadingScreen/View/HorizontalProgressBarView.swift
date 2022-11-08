//
//  HorizontalProgressBarView.swift
//  Komka
//
//  Created by Ryan Vieri Kwa on 03/11/22.
//

import UIKit

class HorizontalProgressBarView: UIView {

    let roundedRectangleLayer = CAShapeLayer()
    let progressLayer = CALayer()
    var roundedRect: UIBezierPath?
    var width = 0.0
    var height = 0.0
    override init(frame: CGRect){
        super.init(frame: frame)
        
        width = self.frame.size.width
        height = self.frame.size.height

        self.backgroundColor = UIColor.black
        let rect = CGRect(x: 10, y: 0, width: width, height: height)
        roundedRect = UIBezierPath(roundedRect: rect, cornerRadius: 30)
        
        createRoundedRectangle()
        createProgressTrackLayer()
    }
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    func createRoundedRectangle() {
        guard let roundedRect = roundedRect else {
            print("Rounded Rectangle path is not available")
            return
        }

        roundedRectangleLayer.path = roundedRect.cgPath
        roundedRectangleLayer.fillColor = UIColor.ProgressBarTrack.cgColor
        roundedRectangleLayer.strokeColor = UIColor.progressBarBorder.cgColor
        roundedRectangleLayer.lineWidth = 10.0
        roundedRectangleLayer.position = CGPoint(x: 0, y: 5)
        roundedRectangleLayer.anchorPoint = CGPoint(x: 0, y: 0)
        layer.addSublayer(roundedRectangleLayer)
    }
    
    func createProgressTrackLayer() {
        progressLayer.bounds = CGRect(x: roundedRectangleLayer.position.x, y: roundedRectangleLayer.position.y, width: 0, height: height-10)
        progressLayer.backgroundColor = UIColor.progreeBarProgress.cgColor
        progressLayer.position = CGPoint(x: 10, y: 10)
        progressLayer.anchorPoint = CGPoint(x: 0, y: 0)
        progressLayer.cornerRadius = 20
        layer.addSublayer(progressLayer)
    }
    func progressAnimation(initialValue: CGFloat, finalValue: CGFloat, duration: TimeInterval) {
        let progressAnimation = CABasicAnimation(keyPath: "bounds.size.width")
        progressAnimation.fromValue = initialValue
        progressAnimation.toValue = finalValue
        progressAnimation.duration = duration
        progressAnimation.fillMode = .forwards
        progressAnimation.isRemovedOnCompletion = false

        progressLayer.add(progressAnimation, forKey: #keyPath(CALayer.bounds))
    }
}
