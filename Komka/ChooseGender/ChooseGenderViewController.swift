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
    
    lazy var titleLbl = createLbl(text: "Pilih Gender Anak", font: 45, textColor: .black)
    
    lazy var maleGenderBtn = createGenderBtn(title: "Male", imgTitle: "BtnMale")
    lazy var maleGenderLbl = createLbl(text: "Laki-Laki", font: 30, textColor: UIColor(named: "bluePastel")!)
    
    lazy var femaleGenderBtn = createGenderBtn(title: "Female", imgTitle: "BtnFemale")
    lazy var femaleGenderLbl = createLbl(text: "Perempuan", font: 30, textColor: UIColor(named: "redPastel")!)
    
    lazy var maleGenderStackView = createStackView(arrangedSubviews: [maleGenderBtn, maleGenderLbl], axis: .vertical, spacing: 30)
    lazy var femaleGenderStackView = createStackView(arrangedSubviews: [femaleGenderBtn, femaleGenderLbl], axis: .vertical, spacing: 30)
    
    lazy var genderStackView = createStackView(arrangedSubviews: [maleGenderStackView, femaleGenderStackView], axis: .horizontal, spacing: 100)
    lazy var genderTitleStackView = createStackView(arrangedSubviews: [titleLbl, genderStackView], axis: .vertical, spacing: 45)
    
    private func createLbl(text: String, font: CGFloat, textColor: UIColor) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.balooFont(size: font)
        label.textColor = textColor
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }
    
    private func createGenderBtn(title: String, imgTitle: String) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.setImage(UIImage(named: imgTitle), for: .normal)
        button.addTarget(self, action: #selector(btnTapped), for: .touchUpInside)
        
        return button
    }
    
    @objc func btnTapped(_ sender: UIButton) {
        // btnTapped logic
    }
    
    private func createStackView(arrangedSubviews: [UIView], axis: NSLayoutConstraint.Axis, spacing: CGFloat) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: arrangedSubviews)
        stack.axis = axis
        stack.spacing = spacing
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
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
        // constraint for maleBtn
        NSLayoutConstraint.activate([
            maleGenderBtn.widthAnchor.constraint(equalToConstant: 155),
            maleGenderBtn.heightAnchor.constraint(equalTo: maleGenderBtn.widthAnchor)
        ])
        
        // constraint for femaleBtn
        NSLayoutConstraint.activate([
            femaleGenderBtn.widthAnchor.constraint(equalToConstant: 155),
            femaleGenderBtn.heightAnchor.constraint(equalTo: femaleGenderBtn.widthAnchor)
        ])
        
        // constraint for genderTitleStackView
        NSLayoutConstraint.activate([
            genderTitleStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            genderTitleStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

}
