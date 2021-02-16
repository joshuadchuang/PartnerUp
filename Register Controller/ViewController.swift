//
//  ViewController.swift
//  PartnerUp
//
//  Created by Joshua Chuang on 12/24/20.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setUpElements()
    }
    
    func setUpElements() {
        Utilities.styleFilledButton(signUpButton)
        Utilities.styleHollowButton(loginButton)
        Utilities.styleRoundedCornerImage(logoImageView)
        Utilities.styleFilledButton(facebookButton)
        Utilities.styleHollowButton(googleButton)
    }


}

