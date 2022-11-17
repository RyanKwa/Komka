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
    private lazy var scenarioLabel = UIView.createLabel(text: "Pilih Skenario", fontSize: 45)
    
    
    //    private lazy var mudahButton: UIButton = {
    //        let button = LevelButton()
    //        button.configure(with: LevelButtonVM(title: "Mudah", image: "ChooseScenario_LevelIdle", size: 30))
    //        button.addTarget(self, action: #selector(levelBtnTapped), for: .touchUpInside)
    //
    //        return button
    
    private var mudahButton: UIButton = {
        let button = LevelController()
        button.configure(with: buttonVM(title: "Mudah", size: 30))
        button.addTarget(self, action: #selector(levelBtnTapped), for: .touchUpInside)
        return button
    }()
    
    private var sedangButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(levelBtnTapped), for: .touchUpInside)
        
        return button
    }()
    
    private var susahButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(levelBtnTapped), for: .touchUpInside)
        
        return button
    }()
    
    private let levelController = LevelController()
    
    private lazy var levelStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [mudahButton, sedangButton, susahButton])
        stack.axis = .horizontal
        stack.distribution = .equalCentering
        stack.spacing = 18
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private var chooseScenarioVM = ChooseScenarioViewModel()
    private var completionVM = CompletionPageViewModel()
    
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
        scenarioCollectionView.showsHorizontalScrollIndicator = false
    }
    
    private func addSubView(){
        view.addSubview(backgroundImg)
        backgroundImg.addSubview(scenarioLabel)
        view.addSubview(scenarioCollectionView)
        view.addSubview(levelStackView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        //For level button array
        levelController.buttonsArray = [mudahButton, sedangButton, susahButton]
        levelController.defaultButton = mudahButton
        
        
        chooseScenarioVM.fetchScenario()
        chooseScenarioVM.setUnlock()
        
        Observable.combineLatest(chooseScenarioVM.scenariosPublisher, chooseScenarioVM.assetsPublisher)
            .observe(on: MainScheduler.instance)
            .subscribe(onCompleted: {
                self.chooseScenarioVM.levelByScenario(level: LevelScenario.mudah.rawValue)
                self.scenarioCollectionView.reloadData()
            })
            .disposed(by: chooseScenarioVM.bag)
        
        addSubView()
        setCollectionView()
        setupAutoLayout()
    }
    
    func setupAutoLayout() {
        scenarioLabel.anchor(top: backgroundImg.topAnchor, paddingTop: ScreenSizeConfiguration.SCREEN_HEIGHT/15)
        scenarioLabel.centerX(inView: backgroundImg)
        
        levelStackView.anchor(top: scenarioLabel.bottomAnchor, paddingTop: ScreenSizeConfiguration.SCREEN_HEIGHT/25, paddingBottom: ScreenSizeConfiguration.SCREEN_HEIGHT/20)
        levelStackView.centerX(inView: backgroundImg)
        
        scenarioCollectionView.anchor(top: levelStackView.bottomAnchor, left: backgroundImg.leftAnchor, bottom: backgroundImg.bottomAnchor, right: backgroundImg.rightAnchor, paddingTop: ScreenSizeConfiguration.SCREEN_HEIGHT/20, paddingLeft: ScreenSizeConfiguration.SCREEN_WIDTH/50, paddingBottom: ScreenSizeConfiguration.SCREEN_HEIGHT/7, paddingRight: ScreenSizeConfiguration.SCREEN_WIDTH/50)
    }
    
    @objc func levelBtnTapped(_ sender: UIButton){
        levelController.buttonArrayUpdated(buttonSelected: sender)
        
        switch sender{
        case mudahButton:
            self.chooseScenarioVM.levelByScenario(level: LevelScenario.mudah.rawValue)
            self.scenarioCollectionView.reloadData()
        case sedangButton:
            self.chooseScenarioVM.levelByScenario(level: LevelScenario.sedang.rawValue)
            self.scenarioCollectionView.reloadData()
        case susahButton:
            self.chooseScenarioVM.levelByScenario(level: LevelScenario.sulit.rawValue)
            self.scenarioCollectionView.reloadData()
        default:
            break
        }
    }
}

extension ChooseScenarioController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ScreenSizeConfiguration.SCREEN_WIDTH/2.7, height: ScreenSizeConfiguration.SCREEN_HEIGHT/2.2)
    }
    
    //Spacing between section atau cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt: Int) -> CGFloat {
        return 36
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chooseScenarioVM.scenarioPerLevel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let scenarioCell = collectionView.dequeueReusableCell(withReuseIdentifier: ScenarioCell.identifier, for: indexPath) as? ScenarioCell,
            let scenarioImage = chooseScenarioVM.assets[indexPath.row].image
        else { return UICollectionViewCell() }
        let scenarioTitle = chooseScenarioVM.scenarioPerLevel[indexPath.row].title
        scenarioCell.scenarioLabel.text = scenarioTitle
        scenarioCell.scenarioLabel.addCharacterSpacing()
        scenarioCell.scenarioImg.image = UIImage.changeImageFromURL(baseImage: scenarioImage)
        
        chooseScenarioVM.unlockPublisher.subscribe { [self] _ in
            if(chooseScenarioVM.isCompleted ?? 0 < chooseScenarioVM.nextLevelPoint ?? 0) {
                scenarioCell.addLockOverlay()
            }
        }.disposed(by: chooseScenarioVM.bag)
        
        //        completionVM.completionPublisher.subscribe { [self] nextLevelPointsNeeded in
        //            if(completionVM.isCompleted < nextLevelPointsNeeded) {
        //                scenarioCell.addLockOverlay()
        //            }
        //        }.disposed(by: completionVM.disposeBag)
        //
        return scenarioCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let stepViewController = MultipleChoiceViewController()
        stepViewController.selectedScenarioId = chooseScenarioVM.scenarioPerLevel[indexPath.row].id
        self.navigationController?.pushViewController(stepViewController, animated: false)
        
        chooseScenarioVM.unlockPublisher.subscribe { [self] _ in
            if(chooseScenarioVM.isCompleted ?? 0 >= chooseScenarioVM.nextLevelPoint ?? 0) {
                let stepViewController = MultipleChoiceViewController()
                stepViewController.selectedScenarioId = chooseScenarioVM.scenarios[indexPath.row].id
                self.navigationController?.pushViewController(stepViewController, animated: false)
            }
        }.disposed(by: chooseScenarioVM.bag)
        
        //        completionVM.completionPublisher.subscribe { [self] nextLevelPointsNeeded in
        //            if(completionVM.isCompleted < nextLevelPointsNeeded) {
        //
        //            }
        //            else{
        //                let stepViewController = MultipleChoiceViewController()
        //                stepViewController.selectedScenarioId = chooseScenarioVM.scenarios[indexPath.row].id
        //                self.navigationController?.pushViewController(stepViewController, animated: false)
        //            }
        //        }.disposed(by: completionVM.disposeBag)
    }
}

