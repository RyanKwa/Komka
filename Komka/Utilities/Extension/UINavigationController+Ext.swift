//
//  UINavigationController+Ext.swift
//  Komka
//
//  Created by Minawati on 05/11/22.
//

import Foundation
import UIKit

extension UINavigationController {
    func popToViewController(_ viewController: AnyClass) {
        if let vc = viewControllers.last(where: { $0.isKind(of: viewController) }) {
            popToViewController(vc, animated: false)
        }
    }
}
