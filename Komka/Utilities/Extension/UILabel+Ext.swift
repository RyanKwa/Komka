//
//  UILabel+Ext.swift
//  Komka
//
//  Created by Minawati on 01/11/22.
//

import Foundation
import UIKit

extension UILabel {
    func addCharacterSpacing(text: String) {
        let string = NSMutableAttributedString(string: text)
        string.addAttribute(NSAttributedString.Key.kern, value: 2.0, range: NSRange(location: 0, length: string.length - 1))
        attributedText = string
    }
}
