//
//  Extension.swift
//  Komka
//
//  Created by Evelin Evelin on 03/10/22.
//

import UIKit

extension UIFont {    
    static func balooFont(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "Baloo2-ExtraBold", size: size) else {
            return UIFont.systemFont(ofSize: size)
          }
        return font
    }
}
