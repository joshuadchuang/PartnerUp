//
//  Utilities.swift
//  PartnerUp
//
//  Created by Joshua Chuang on 12/27/20.
//

import Foundation
import UIKit

// Set up the styling for all components

class Utilities {
    
    static func styleTextField(_ textfield:UITextField) {
        
        // Create the bottom line
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 2)
        
        bottomLine.backgroundColor = UIColor.init(red: 0/255, green: 150/255, blue: 255/255, alpha: 1).cgColor
        
        // Remove border on text field
        textfield.borderStyle = .none
        
        // Add the line to the text field
        textfield.layer.addSublayer(bottomLine)
        
    }
    
    static func styleFilledButton(_ button:UIButton) {
        
        // Filled rounded corner style
        button.backgroundColor = .link
        button.layer.cornerRadius = 10.0
        button.tintColor = UIColor.white
        button.layer.shadowColor = UIColor.darkGray.cgColor
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize( width: 0, height: 0)
    }
    
    static func styleHollowButton(_ button:UIButton) {
        
        // Hollow rounded corner style
        button.layer.backgroundColor = UIColor.white.cgColor
        button.layer.cornerRadius = 10.0
        button.tintColor = UIColor.black
        button.layer.shadowColor = UIColor.darkGray.cgColor
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize( width: 0, height: 0)
    }
    
    static func styleRoundedCornerImage(_ image:UIImageView) {

        // Rounded corner style
        image.layer.cornerRadius = 20.0
    }
    
    // Password restrictions
    static func isPasswordValid(_ password : String) -> Bool{
        
        // Checks if:
            // Password length is 8
            // One uppercase
            // One lowercase
            // One number
            // One special character
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{8,}")
        return passwordTest.evaluate(with: password)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
