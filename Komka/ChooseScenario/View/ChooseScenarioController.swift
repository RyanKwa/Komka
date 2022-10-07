//
//  ChooseScenarioController.swift
//  Komka
//
//  Created by Evelin Evelin on 04/10/22.
//

import UIKit

class ChooseScenarioController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(ScenarioCell.self, forCellWithReuseIdentifier: "cell")
        
        return cv
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
            collectionView.heightAnchor.constraint(equalToConstant: view.frame.height/1.5)
        ])
    }

    private func assignbackground(){
        let imageView = UIImageView(frame: view.bounds)
        
        imageView.contentMode =  .scaleAspectFill
        imageView.image = #imageLiteral(resourceName: "bg")
        view.addSubview(imageView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        assignbackground()
        view.addSubview(collectionView)
        setCollectionView()
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ScenarioCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(ViewController(), animated: true)
        print("Tapped \(indexPath)")
    }

}
