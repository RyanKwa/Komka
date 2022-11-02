//
//  ChooseGenderViewController.swift
//  Komka
//
//  Created by Minawati on 11/10/22.
//

import UIKit

class ChooseGenderViewController: UIViewController {

    lazy var chooseGenderVM: ChooseGenderViewModel = ChooseGenderViewModel()
    
    lazy var backgroundImg = UIView.createImageView(imageName: "bg")
    
    lazy var titleLbl = UIView.createLabel(text: "Pilih Gender Anak", fontSize: 45)
    
    lazy var maleGenderBtn: UIButton = {
        let button = UIView.createImageIconBtn(title: "Male", imgTitle: "BtnMale")
        button.addTarget(self, action: #selector(btnTapped), for: .touchUpInside)
        
        return button
    }()
    lazy var maleGenderLbl = UIView.createLabel(text: "Laki-Laki", fontSize: 30, textColor: UIColor(named: "bluePastel"))
    
    lazy var femaleGenderBtn: UIButton = {
        let button = UIView.createImageIconBtn(title: "Female", imgTitle: "BtnFemale")
        button.addTarget(self, action: #selector(btnTapped), for: .touchUpInside)
        
        return button
    }()
    lazy var femaleGenderLbl = UIView.createLabel(text: "Perempuan", fontSize: 30, textColor: UIColor(named: "redPastel"))
    
    lazy var maleGenderStackView = UIView.createStackView(arrangedSubviews: [maleGenderBtn, maleGenderLbl], axis: .vertical, spacing: 35, alignment: .center)
    lazy var femaleGenderStackView = UIView.createStackView(arrangedSubviews: [femaleGenderBtn, femaleGenderLbl], axis: .vertical, spacing: 35, alignment: .center)
    
    lazy var genderStackView = UIView.createStackView(arrangedSubviews: [maleGenderStackView, femaleGenderStackView], axis: .horizontal, spacing: 100, alignment: .center)
    lazy var genderTitleStackView = UIView.createStackView(arrangedSubviews: [titleLbl, genderStackView], axis: .vertical, spacing: 45, alignment: .center)
    
    @objc func btnTapped(_ sender: UIButton) {
        guard let gender = sender.titleLabel?.text else { return }
        
        chooseGenderVM.addGenderToKeyValueStore(gender: gender)
        
        navigationController?.pushViewController(ChooseScenarioController(), animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupConstraint()
    }
    
    private func setupView() {
        view.addSubview(backgroundImg)
        view.addSubview(genderTitleStackView)
    }
    
    private func setupConstraint(){

        let genderBtnSize = ScreenSizeConfiguration.SCREEN_WIDTH/8+6
        
        // constraint for maleBtn
        maleGenderBtn.setDimensions(width: genderBtnSize, height: genderBtnSize)
        
        // constraint for femaleBtn
        femaleGenderBtn.setDimensions(width: genderBtnSize, height: genderBtnSize)
        
        // constraint for genderTitleStackView
        genderTitleStackView.center(inView: view)
    }

}
