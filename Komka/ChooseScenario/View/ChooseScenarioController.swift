//
//  ChooseScenarioController.swift
//  Komka
//
//  Created by Evelin Evelin on 04/10/22.
//

import UIKit

class ChooseScenarioController: UIViewController {
    
    private lazy var titleLabel = TitleLabel(title: "Pilih Skenario", fontSize: 45)
    
    private lazy var btnMudah: UIButton = {
        let button = LevelButton()
        button.configure(with: LevelButtonVM(title: "Mudah", image: "ChooseScenario_LevelIdle", size: 30))
        button.addTarget(self, action:#selector(levelBtnTapped), for: .touchUpInside)
        return button
    }()

    private lazy var btnSedang: UIButton = {
        let button = LevelButton()
        button.configure(with: LevelButtonVM(title: "Sedang", image: "ChooseScenario_LevelIdle", size: 30))
        button.addTarget(self, action:#selector(levelBtnTapped), for: .touchUpInside)
        return button
    }()

    private lazy var btnSusah: UIButton = {
        let button = LevelButton()
        button.configure(with: LevelButtonVM(title: "Susah", image: "ChooseScenario_LevelIdle", size: 30))
        button.addTarget(self, action:#selector(levelBtnTapped), for: .touchUpInside)
        return button
    }()
    

    
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
        rewardBtn.addTarget(self, action: #selector(rewardBtnTapped), for: .touchUpInside)
        
        return rewardBtn
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let scenarioViewCell = UICollectionView(frame: .zero, collectionViewLayout: layout)
        scenarioViewCell.translatesAutoresizingMaskIntoConstraints = false
        scenarioViewCell.register(ScenarioCell.self, forCellWithReuseIdentifier: ScenarioCell.identifier)
        
        return scenarioViewCell
    }()
    
    private func setCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
        collectionView.clipsToBounds = false
        
        NSLayoutConstraint.activate([
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40),
            collectionView.heightAnchor.constraint(equalToConstant: view.frame.height/1.6)
        ])
    }

    private func assignbackground(){
        let imageView = UIImageView(frame: view.bounds)
        
        imageView.contentMode =  .scaleToFill
        imageView.image = #imageLiteral(resourceName: "bg")
        view.addSubview(imageView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        assignbackground()
        view.addSubview(collectionView)
        setCollectionView()
        view.addSubview(titleLabel)
        view.addSubview(stackView)
        view.addSubview(rewardButton)
        setupAutoLayout()
    }
    
   private func setupAutoLayout() {
        NSLayoutConstraint.activate([

            
            rewardButton.topAnchor.constraint(equalTo:view.topAnchor, constant: 59),
            rewardButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 64),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stackView.topAnchor.constraint(equalTo:titleLabel.bottomAnchor, constant: 29),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc func levelBtnTapped(_ sender: UIButton){
        for subView in view.subviews{
            if let button = subView as? UIButton {
                button.isSelected = false
            }
        }
        sender.isSelected = true
        sender.setBackgroundImage(UIImage(named: "ChooseScenario_LevelActive"), for: .normal)

    }
    
    @objc func rewardBtnTapped(_ sender: UIButton){
        navigationController?.pushViewController(RewardViewController(), animated: false)
    }
}

extension ChooseScenarioController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/3, height: collectionView.frame.height/2)
    }
    
    //Spacing between section atau cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt: Int) -> CGFloat {
        return 36
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let scenarioCell = collectionView.dequeueReusableCell(withReuseIdentifier: ScenarioCell.identifier, for: indexPath) as? ScenarioCell else { return UICollectionViewCell() }
        
        return scenarioCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(ViewController(), animated: true)
    }

}


