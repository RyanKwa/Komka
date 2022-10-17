//
//  LevelButton.swift
//  Komka
//
//  Created by Minawati on 13/10/22.
//

import Foundation
import UIKit

struct LevelButtonVM{
    let title: String
    let image: String
    let size: CGFloat
}

class LevelButton: UIButton {
    
    override init(frame: CGRect){
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: LevelButtonVM) {
        self.setTitle(viewModel.title, for: .normal)
        setBackgroundImage(UIImage(named: viewModel.image), for: .normal)
        titleLabel?.font = UIFont(name: "Baloo2-ExtraBold", size: viewModel.size)
        
        
    }
}
