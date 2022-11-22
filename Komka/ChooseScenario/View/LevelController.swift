//
//  LevelController.swift
//  Komka
//
//  Created by Shaqina Yasmin on 16/11/22.
//

import UIKit



class LevelController: UIButton {
    var buttonsArray: [UIButton] = [] {
        // MARK: didSet is called immediately after the new value is stored.
        // MARK: Set button property after the new value is assigned
        didSet {
            for button in buttonsArray {
                button.setImage(UIImage(named: "ChooseScenario_LevelIdle"), for: .normal)
                button.setImage(UIImage(named: "ChooseScenario_LevelActive"), for: .selected)

            }
        }
    }
    
    var selectedButton: UIButton?
    
    // MARK: set default selected button a.k.a mudah
    var defaultButton: UIButton = UIButton() {
        didSet {
            buttonArrayUpdated(buttonSelected: self.defaultButton)
        }
    }
    
    // MARK: update selected button
    func buttonArrayUpdated(buttonSelected: UIButton) {
        for button in buttonsArray {
            if button == buttonSelected {
                selectedButton = button
                button.isSelected = true
            } else {
                button.isSelected = false
            }
        }
    }
}
