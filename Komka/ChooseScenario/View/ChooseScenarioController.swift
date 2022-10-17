//
//  ChooseScenarioController.swift
//  Komka
//
//  Created by Evelin Evelin on 04/10/22.
//

import UIKit

class ChooseScenarioController: UIViewController {
    
    private lazy var btnMudah = Button(style: .active, title: "Mudah")
    private lazy var btnSedang = Button(style: .idle, title: "Sedang")
    private lazy var btnSusah = Button(style: .idle, title: "Susah")
    
    lazy var backgroundImg = UIView.setImageView(imageName: "bg")
    
    private var vm = ChooseScenarioViewModel()
        
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
        
        collectionView.anchor(bottom: view.bottomAnchor, paddingBottom: 40)
        collectionView.anchor(left: view.leftAnchor, paddingLeft: 40)
        collectionView.anchor(right: view.rightAnchor, paddingLeft: 40)
        collectionView.anchor(height: ScreenSizeConfiguration.SCREEN_HEIGHT/1.6)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        DispatchQueue.main.asyncAfter(deadline: .now()+2){
            self.collectionView.reloadData()
        }
        
        view.addSubview(backgroundImg)
        view.addSubview(stackView)
        view.addSubview(rewardButton)
        setupAutoLayout()
        view.addSubview(collectionView)
        setCollectionView()
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

extension ChooseScenarioController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/3, height: collectionView.frame.height/2)
    }
    
    //Spacing between section atau cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt: Int) -> CGFloat {
        return 36
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.scenarios.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let scenarioCell = collectionView.dequeueReusableCell(withReuseIdentifier: ScenarioCell.identifier, for: indexPath) as? ScenarioCell,
            let scenarioImage = vm.assets[indexPath.row].image
        else { return UICollectionViewCell() }
        let scenarioTitle = vm.scenarios[indexPath.row].title
        scenarioCell.scenarioLabel.text = scenarioTitle
        scenarioCell.scenarioImg.image = UIImage.changeImageFromURL(baseImage: scenarioImage)
        
        return scenarioCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let stepViewController = MultipleChoiceViewController(nibName: nil, bundle: nil)
        stepViewController.currentScenario = "RuangMakanCover"
        self.navigationController?.pushViewController(stepViewController, animated: true)
    }

}
