//
//  LevelViewController.swift
//  Komka
//
//  Created by Shaqina Yasmin on 06/10/22.
//

import UIKit

class LevelViewController: UIViewController {

    private lazy var btnMudah = Button(style: .active, title: "Mudah")
    private lazy var btnSedang = Button(style: .idle, title: "Sedang")
    private lazy var btnSusah = Button(style: .idle, title: "Susah")
    
    
    private lazy var stackView : UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [btnMudah, btnSedang, btnSusah])
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.spacing = 18
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var rewardButton : UIButton = {
        let rewardBtn = UIButton()
        rewardBtn.setBackgroundImage(UIImage(named: "RewardBtn.png"), for: .normal)
        rewardBtn.translatesAutoresizingMaskIntoConstraints = false
        rewardBtn.widthAnchor.constraint(equalToConstant: 100).isActive = true
        rewardBtn.heightAnchor.constraint(equalToConstant: 89).isActive = true
        return rewardBtn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(stackView)
        view.addSubview(rewardButton)
        setupAutoLayout()
    }
    
    func setupAutoLayout() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor, constant: 164),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            rewardButton.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor, constant: 59),
            rewardButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -27)
        ])
        
        
    }
    
}
