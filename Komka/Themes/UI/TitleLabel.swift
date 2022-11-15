//
//  TitleLabel.swift
//  Komka
//
//  Created by Shaqina Yasmin on 13/10/22.
//

import UIKit

struct TitleLabelVM {
    let textLabel: String
    let fontSize: CGFloat
}

class TitleLabel: UILabel {

//    override init(frame: CGRect){
//        super.init(frame: frame)
//        translatesAutoresizingMaskIntoConstraints = false
//    }
//    required init(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func configure(with viewModel: TitleLabelVM) {
//        textAlignment = .center
//        textColor = UIColor(named: "brownColor")
//        font = UIFont.balooFont(size: viewModel.fontSize)
//
//    }
    
    
    public private(set) var title: String
    public private(set) var fontSize:CGFloat
    
    init(title: String, fontSize: CGFloat) {
        self.title = title
        self.fontSize = fontSize
        
        super.init(frame: .zero)
        configure()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.font = UIFont.balooFont(size: fontSize)
        self.text = title
        self.textColor = UIColor(named: "brownColor")
        self.textAlignment = .center
        self.translatesAutoresizingMaskIntoConstraints = false

        
    }
}


