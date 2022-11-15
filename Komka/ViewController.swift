//
//  ViewController.swift
//  Komka
//
//  Created by Ryan Vieri Kwa on 29/09/22.
//

import UIKit

class ViewController: UIViewController {
    var hideStatusBar: Bool = true {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    override var prefersStatusBarHidden: Bool {
           return hideStatusBar
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

