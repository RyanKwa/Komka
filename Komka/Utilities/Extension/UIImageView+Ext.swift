//
//  UIImageView+Ext.swift
//  Komka
//
//  Created by Minawati on 13/10/22.
//

import Foundation
import UIKit

extension UIImageView {
    
    func addWhiteOverlay() {
        let overlay: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        overlay.backgroundColor = UIColor(white: 1, alpha: 0.7)
        self.addSubview(overlay)
    }
}
