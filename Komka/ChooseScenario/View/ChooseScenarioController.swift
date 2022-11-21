//
//  ChooseScenarioController.swift
//  Komka
//
//  Created by Evelin Evelin on 04/10/22.
//

import UIKit
import RxSwift

class ChooseScenarioController: ViewController, ErrorViewDelegate {

    private lazy var backgroundImg = UIView.createImageView(imageName: "bg")
    private lazy var scenarioLabel = UIView.createLabel(text: "Pilih Skenario", fontSize: 45)

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
    
    private func createToast(level: String){
        let unlockImage = NSTextAttachment()
        unlockImage.image = UIImage(systemName: "lock.open.fill")
        
        let labelString = NSMutableAttributedString(string: "Selamat! Level \(level.capitalized) sudah terbuka ")
        labelString.append(NSAttributedString(attachment: unlockImage))

        let toastLabel = UILabel()
        toastLabel.font = UIFont.balooFont(size: 25)
        toastLabel.attributedText = labelString
        toastLabel.backgroundColor = .white.withAlphaComponent(1)
        toastLabel.textAlignment = .center
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        
        view.addSubview(toastLabel)
        toastLabel.centerX(inView: view)
        toastLabel.anchor(top: levelStackView.bottomAnchor, paddingTop: ScreenSizeConfiguration.SCREEN_HEIGHT/50)
        toastLabel.setDimensions(width: ScreenSizeConfiguration.SCREEN_WIDTH/2.3, height: 45)
        
        UIView.animate(withDuration: 5.0, delay: 0.5, options: .curveEaseIn) {
            toastLabel.alpha = 0.0
        } completion: { isCompleted in
            toastLabel.removeFromSuperview()
        }
    }
    
    private func showToast(){
        Observable.combineLatest(chooseScenarioVM.scenariosPublisher, chooseScenarioVM.assetsPublisher)
            .observe(on: MainScheduler.instance)
            .subscribe(onCompleted: { [self] in
                if(chooseScenarioVM.isCompleted == chooseScenarioVM.scenarioPerLevel.count) {
                    createToast(level: LevelScenario.sedang.rawValue)
                }
                else if (chooseScenarioVM.isCompleted == (chooseScenarioVM.scenarioPerLevel.count * 2)) {
                    createToast(level: LevelScenario.sulit.rawValue)
                }
            })
            .disposed(by: chooseScenarioVM.bag)
    }
    
    private func addSubView(){
        view.addSubview(backgroundImg)
        backgroundImg.addSubview(scenarioLabel)
        view.addSubview(scenarioCollectionView)
        view.addSubview(levelStackView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        chooseScenarioVM.isCompleted = chooseScenarioVM.updateCompletedScenarioValue()
        showToast()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        levelController.buttonsArray = [mudahButton, sedangButton, susahButton]
        levelController.defaultButton = mudahButton
        
        chooseScenarioVM.fetchScenario()
        
        Observable.combineLatest(chooseScenarioVM.scenariosPublisher, chooseScenarioVM.assetsPublisher)
            .observe(on: MainScheduler())
            .subscribe(onError: { [weak self] error in
                if let fetchError = error as? FetchError {
                    let errorView = ErrorViewController()
                    errorView.delegate = self
                    errorView.errorDescription = fetchError.localizedDescription
                    errorView.errorTitleMessage = fetchError.errorTitle
                    errorView.errorGuidance = fetchError.errorGuidance
                    print(error.localizedDescription)
                    self?.navigationController?.pushViewController(errorView, animated: false)
                }
            }, onCompleted: {
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
        case sedangButton:
            self.chooseScenarioVM.levelByScenario(level: LevelScenario.sedang.rawValue)
        case susahButton:
            self.chooseScenarioVM.levelByScenario(level: LevelScenario.sulit.rawValue)
        default:
            break
        }
        self.scenarioCollectionView.reloadData()
    }

    func closeBtnTapped() {
        self.navigationController?.popToViewController(ChooseScenarioController.self)
    }

    func cobaLagiBtnTapped() {
        self.navigationController?.popToViewController(ChooseScenarioController.self)
    }

}

extension ChooseScenarioController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ScreenSizeConfiguration.SCREEN_WIDTH/2.7, height: ScreenSizeConfiguration.SCREEN_HEIGHT/2.2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt: Int) -> CGFloat {
        return 36
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chooseScenarioVM.scenarioPerLevel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard chooseScenarioVM.scenarios.count > 0 && chooseScenarioVM.assets.count > 0 else {
            collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "default")
            return collectionView.dequeueReusableCell(withReuseIdentifier: "default", for: indexPath)
        }
        guard
            let scenarioCell = collectionView.dequeueReusableCell(withReuseIdentifier: ScenarioCell.identifier, for: indexPath) as? ScenarioCell,
            let scenarioImage = chooseScenarioVM.assets[indexPath.row].image
        else {
            collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "default")
            return collectionView.dequeueReusableCell(withReuseIdentifier: "default", for: indexPath)
        }
        let scenarioTitle = chooseScenarioVM.scenarioPerLevel[indexPath.row].title
        scenarioCell.scenarioLabel.text = scenarioTitle
        scenarioCell.scenarioLabel.addCharacterSpacing()
        scenarioCell.scenarioImg.image = UIImage.changeImageFromURL(baseImage: scenarioImage)
        
        let scenarioLevel = chooseScenarioVM.scenarioPerLevel[indexPath.row].levelScenario
        
        if (chooseScenarioVM.isCompleted ?? 0 < chooseScenarioVM.scenarioPerLevel.count) {
            if(scenarioLevel == LevelScenario.sedang.rawValue || scenarioLevel == LevelScenario.sulit.rawValue) {
                scenarioCell.addLockOverlay(isHidden: false)
            }
            else {
                scenarioCell.addLockOverlay(isHidden: true)
            }
        }
        else if (chooseScenarioVM.isCompleted ?? 0 < (chooseScenarioVM.scenarioPerLevel.count * 2)) {
            if(scenarioLevel == LevelScenario.sulit.rawValue) {
                scenarioCell.addLockOverlay(isHidden: false)
            }
            else {
                scenarioCell.addLockOverlay(isHidden: true)
            }
        }
        return scenarioCell
    }
    
    func moveToNextPage(didSelectItemAt indexPath: IndexPath){
        let stepViewController = MultipleChoiceViewController()
        stepViewController.selectedScenarioId = chooseScenarioVM.scenarioPerLevel[indexPath.row].id
        self.navigationController?.pushViewController(stepViewController, animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let scenarioLevel = chooseScenarioVM.scenarioPerLevel[indexPath.row].levelScenario
        
        if(chooseScenarioVM.isCompleted ?? 0 < chooseScenarioVM.scenarioPerLevel.count) {
            if(scenarioLevel == LevelScenario.mudah.rawValue){
                moveToNextPage(didSelectItemAt: indexPath)
            }
        }
        else if (chooseScenarioVM.isCompleted ?? 0 < (chooseScenarioVM.scenarioPerLevel.count * 2)) {
            if(scenarioLevel == LevelScenario.mudah.rawValue || scenarioLevel == LevelScenario.sedang.rawValue){
                moveToNextPage(didSelectItemAt: indexPath)
            }
        }
        else {
            moveToNextPage(didSelectItemAt: indexPath)
        }
    }
}

