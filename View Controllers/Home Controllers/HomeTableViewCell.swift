//
//  HomeTableViewCell.swift
//  PartnerUp
//
//  Created by Joshua Chuang on 2/13/21.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    // MARK: Outlet Variables
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var majorLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var pfpImageView: UIImageView!
    
    // MARK: Helper Function
    
    /// Links the shapeList to the UI components
    func setShape(shape: Shape) {
        nameLabel.text = shape.name
        pfpImageView.image = UIImage(named: shape.imageName)
        majorLabel.text = shape.major
        cityLabel.text = shape.city
    }
    
    // MARK: Loading Functions <-- These are default to pair with the HomeTableViewCell nib
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
