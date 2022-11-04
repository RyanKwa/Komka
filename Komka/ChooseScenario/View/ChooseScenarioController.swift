//
//  ChooseScenarioController.swift
//  Komka
//
//  Created by Evelin Evelin on 04/10/22.
//

import UIKit
import RxSwift

class ChooseScenarioController: UIViewController {
    private lazy var backgroundImg = UIView.createImageView(imageName: "bg")
    private lazy var scenarioLabel = UIView.createLabel(text: "Pilih Skenario", fontSize: 40)
    
    private var vm = ChooseScenarioViewModel()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let scenarioViewCell = UICollectionView(frame: .zero, collectionViewLayout: layout)
        scenarioViewCell.translatesAutoresizingMaskIntoConstraints = false
        scenarioViewCell.isScrollEnabled = true
        scenarioViewCell.register(ScenarioCell.self, forCellWithReuseIdentifier: ScenarioCell.identifier)
        
        return scenarioViewCell
    }()
    
    private func setCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
        collectionView.clipsToBounds = false
    }
    
    private func addSubView(){
        view.addSubview(backgroundImg)
        backgroundImg.addSubview(scenarioLabel)
        view.addSubview(collectionView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        vm.fetchScenario()
        
        Observable.combineLatest(vm.scenariosPublisher, vm.assetsPublisher)
            .observe(on: MainScheduler.instance)
            .subscribe(onCompleted: {
                self.collectionView.reloadData()
            })
            .disposed(by: vm.bag)


        addSubView()
        setCollectionView()
        setupAutoLayout()
    }
        
    func setupAutoLayout() {
        scenarioLabel.anchor(top: backgroundImg.topAnchor, paddingTop: ScreenSizeConfiguration.SCREEN_HEIGHT/10)
        scenarioLabel.centerX(inView: backgroundImg)
    
        collectionView.anchor(left: backgroundImg.leftAnchor, bottom: backgroundImg.bottomAnchor, right: backgroundImg.rightAnchor, paddingLeft: 40, paddingBottom: 40, paddingRight: 40, height: ScreenSizeConfiguration.SCREEN_HEIGHT/1.6)

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
        let stepViewController = MultipleChoiceViewController(scenarioRecordId: vm.scenarios[indexPath.row].id)
        self.navigationController?.pushViewController(stepViewController, animated: false)
    }

}
