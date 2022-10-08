//
//  ChooseGenderViewController.swift
//  Komka
//
//  Created by Minawati on 06/10/22.
//

import UIKit

class ChooseGenderViewController: UIViewController {

    lazy var backgroundImg: UIImageView = {
        let backgroundImg = UIImageView(frame: UIScreen.main.bounds)
        backgroundImg.image = UIImage(named: "Bg")
        backgroundImg.contentMode = .scaleToFill
        self.view.insertSubview(backgroundImg, at: 0)
        
        return backgroundImg
    }()
    
    lazy var titleLbl = UIView.createLabel(text: "Pilih Gender Anak", fontSize: 45)
    
    lazy var maleGenderBtn = createGenderBtn(title: "Male", imgTitle: "BtnMale")
    lazy var maleGenderLbl = UIView.createLabel(text: "Laki-Laki", fontSize: 30, textColor: UIColor.bluePastel)
    
    lazy var femaleGenderBtn = createGenderBtn(title: "Female", imgTitle: "BtnFemale")
    lazy var femaleGenderLbl = UIView.createLabel(text: "Perempuan", fontSize: 30, textColor: UIColor.redPastel)
    
    lazy var maleGenderStackView = UIView.createStackView(arrangedSubviews: [maleGenderBtn, maleGenderLbl], axis: .vertical, spacing: 35, alignment: .center)
    lazy var femaleGenderStackView = UIView.createStackView(arrangedSubviews: [femaleGenderBtn, femaleGenderLbl], axis: .vertical, spacing: 35, alignment: .center)
    
    lazy var genderStackView = UIView.createStackView(arrangedSubviews: [maleGenderStackView, femaleGenderStackView], axis: .horizontal, spacing: 100, alignment: .center)
    lazy var genderTitleStackView = UIView.createStackView(arrangedSubviews: [titleLbl, genderStackView], axis: .vertical, spacing: 45, alignment: .center)
    
    private func createGenderBtn(title: String, imgTitle: String) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.setImage(UIImage(named: imgTitle), for: .normal)
        button.addTarget(self, action: #selector(btnTapped), for: .touchUpInside)
        
        return button
    }
    
    @objc func btnTapped(_ sender: UIButton) {
        guard let gender = sender.titleLabel?.text else { return }
        
        if !gender.isEmpty {
            NSUbiquitousKeyValueStore.default.hasChooseGender = gender
        }
        
        navigationController?.pushViewController(ChooseScenarioViewController(), animated: false)
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