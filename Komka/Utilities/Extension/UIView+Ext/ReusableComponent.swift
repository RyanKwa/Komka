//
//  ReusableComponent.swift
//  Komka
//
//  Created by Minawati on 11/10/22.
//

import Foundation
import UIKit

extension UIView {
    
    static func setBackgroundImage() -> UIImageView {
        let backgroundImg = UIImageView(frame: UIScreen.main.bounds)
        backgroundImg.contentMode = .scaleToFill
        backgroundImg.image = #imageLiteral(resourceName: "bg")
        
        return backgroundImg
    }
    
    static func createLabel(text: String,
                            fontSize: CGFloat,
                            textColor: UIColor? = .black) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.balooFont(size: fontSize)
        label.textColor = textColor

        return label
    }

    static func createStackView(arrangedSubviews: [UIView],
                                axis: NSLayoutConstraint.Axis,
                                spacing: CGFloat,
                                distribution: UIStackView.Distribution? = .equalCentering,
                                alignment: UIStackView.Alignment? = .fill) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: arrangedSubviews)
        stack.axis = axis
        stack.spacing = spacing
        stack.distribution = distribution ?? .equalCentering
        stack.alignment = alignment ?? .fill

        return stack
    }
}
