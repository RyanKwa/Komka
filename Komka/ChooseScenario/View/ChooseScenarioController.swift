//
//  ChooseScenarioController.swift
//  Komka
//
//  Created by Evelin Evelin on 04/10/22.
//

import UIKit
import RxSwift

class ChooseScenarioController: ViewController {
    private lazy var backgroundImg = UIView.createImageView(imageName: "bg")
    private lazy var scenarioLabel = UIView.createLabel(text: "Pilih Skenario", fontSize: 40)
    
    private var chooseScenarioVM = ChooseScenarioViewModel()
    
    private lazy var scenarioCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let scenarioViewCell = UICollectionView(frame: .zero, collectionViewLayout: layout)
        scenarioViewCell.translatesAutoresizingMaskIntoConstraints = false
        scenarioViewCell.isScrollEnabled = true
        scenarioViewCell.register(ScenarioCell.self, forCellWithReuseIdentifier: ScenarioCell.identifier)
        
        return scenarioViewCell
    }()
    
    private func setCollectionView(){
        scenarioCollectionView.delegate = self
        scenarioCollectionView.dataSource = self
        scenarioCollectionView.backgroundColor = UIColor.clear
        scenarioCollectionView.clipsToBounds = false
    }
    
    private func addSubView(){
        view.addSubview(backgroundImg)
        backgroundImg.addSubview(scenarioLabel)
        view.addSubview(scenarioCollectionView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        chooseScenarioVM.fetchScenario()

        Observable.combineLatest(chooseScenarioVM.scenariosPublisher, chooseScenarioVM.assetsPublisher)
            .observe(on: MainScheduler.instance)
            .subscribe(onCompleted: {
                self.scenarioCollectionView.reloadData()
            })
            .disposed(by: chooseScenarioVM.bag)

        addSubView()
        setCollectionView()
        setupAutoLayout()
    }
        
    func setupAutoLayout() {
        scenarioLabel.anchor(top: backgroundImg.topAnchor, paddingTop: ScreenSizeConfiguration.SCREEN_HEIGHT/18)
        scenarioLabel.centerX(inView: backgroundImg)
    
        scenarioCollectionView.anchor(top: scenarioLabel.bottomAnchor, left: backgroundImg.leftAnchor, bottom: backgroundImg.bottomAnchor, right: backgroundImg.rightAnchor, paddingTop: ScreenSizeConfiguration.SCREEN_HEIGHT/19, paddingLeft: ScreenSizeConfiguration.SCREEN_WIDTH/50, paddingBottom: ScreenSizeConfiguration.SCREEN_HEIGHT/7, paddingRight: ScreenSizeConfiguration.SCREEN_WIDTH/50)
    }
}

extension ChooseScenarioController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ScreenSizeConfiguration.SCREEN_WIDTH/2.5, height: ScreenSizeConfiguration.SCREEN_HEIGHT/2)
    }
    
    //Spacing between section atau cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt: Int) -> CGFloat {
        return 36
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chooseScenarioVM.scenarios.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let scenarioCell = collectionView.dequeueReusableCell(withReuseIdentifier: ScenarioCell.identifier, for: indexPath) as? ScenarioCell,
            let scenarioImage = chooseScenarioVM.assets[indexPath.row].image
        else { return UICollectionViewCell() }
        let scenarioTitle = chooseScenarioVM.scenarios[indexPath.row].title
        scenarioCell.scenarioLabel.text = scenarioTitle
        scenarioCell.scenarioLabel.addCharacterSpacing()
        scenarioCell.scenarioImg.image = UIImage.changeImageFromURL(baseImage: scenarioImage)
        
        return scenarioCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let stepViewController = MultipleChoiceViewController()
        stepViewController.selectedScenarioId = chooseScenarioVM.scenarios[indexPath.row].id
        self.navigationController?.pushViewController(stepViewController, animated: false)
    }

}
