//
//  HomeDetailViewController.swift
//  PartnerUp
//
//  Created by Joshua Chuang on 2/13/21.
//

import UIKit

class HomeDetailViewController: UIViewController {

    // MARK: Variables
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pfpImageView: UIImageView!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet var bioLabel: UILabel!
    
    var selectedShape : Shape!
    
    // MARK: Action Function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = selectedShape.name
        pfpImageView.image = UIImage(named: selectedShape.imageName)
        majorLabel.text = selectedShape.major
        cityLabel.text = selectedShape.city
        bioLabel.text = selectedShape.bio
    }
    
    

}
