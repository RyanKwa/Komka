//
//  LevelController.swift
//  Komka
//
//  Created by Shaqina Yasmin on 16/11/22.
//

import UIKit

struct buttonVM{
    let title: String
    let size: CGFloat
}

class LevelController: UIButton {
    var buttonsArray: [UIButton]!  {
        didSet {
            for button in buttonsArray {
                button.setImage(UIImage(named: "ChooseScenario_LevelIdle"), for: .normal)
                button.setImage(UIImage(named: "ChooseScenario_LevelActive"), for: .selected)

            }
        }
    }
    var selectedButton: UIButton?
    var defaultButton: UIButton = UIButton() {
        didSet {
            buttonArrayUpdated(buttonSelected: self.defaultButton)
        }
    }
    
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
    
    func configure(with viewModel: buttonVM) {
        self.setTitle(viewModel.title, for: .normal)
        titleLabel?.font = UIFont(name: "Baloo2-ExtraBold", size: viewModel.size)

    }
    
    
}
