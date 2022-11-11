//
//  UILabel+Ext.swift
//  Komka
//
//  Created by Minawati on 01/11/22.
//

import Foundation
import UIKit

extension UILabel {
    func addCharacterSpacing() {
        let string = NSMutableAttributedString(string: self.text ?? "Text")
        string.addAttribute(NSAttributedString.Key.kern, value: 1.5, range: NSRange(location: 0, length: string.length - 1))
        attributedText = string
    }
}
