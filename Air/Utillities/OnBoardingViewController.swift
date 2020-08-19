//
//  OnBoardingViewController.swift
//  Air
//
//  Created by Gokul Nair on 19/08/20.
//  Copyright © 2020 Gokul Nair. All rights reserved.
//

import UIKit

class OnBoardingViewController: UIViewController {

    @IBOutlet weak var onBoardingBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        onBoardingBtn.layer.cornerRadius = 10
    }
    

    @IBAction func onBoardingBtn(_ sender: Any) {
        self.dismiss(animated:true)
        core.shared.setIsNotNewUser()
    }
    

}
