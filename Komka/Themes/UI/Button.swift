//
//  Button.swift
//  Komka
//
//  Created by Shaqina Yasmin on 06/10/22.
//

import UIKit

//For longer buttons or buttons that is similar to the level buttons/
class Button: UIButton {
    enum Style {
        case active
        case idle
    }
    
    public private(set) var style: Style
    public private(set) var title: String
    
    
    init(style: Style, title: String) {
        self.style = style
        self.title = title
        
        super.init(frame: .zero)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        handleStyleButton()
        buttonSetup()
    }
    
    private func handleStyleButton() {
        setBackgroundImage(UIImage(named: "ChooseScenario_LevelIdle"), for: .normal)
        setBackgroundImage(UIImage(named: "ChooseScenario_LevelActive"), for: .selected)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: 200).isActive = true
        self.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    private func buttonSetup() {
        setTitle(title, for: .normal)
        titleLabel?.font = UIFont(name: "Baloo2-ExtraBold", size: 30)
    }
    
}
