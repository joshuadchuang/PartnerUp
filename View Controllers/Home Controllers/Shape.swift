//
//  Shape.swift
//  PartnerUp
//
//  Created by Joshua Chuang on 1/21/21.
//

import Foundation
import UIKit

class Shape {
    
    // MARK: This is the structure for all of the Home viewable users
    
    var name: String!
    var imageName: String!
    var major: String!
    var city: String!
    var bio: String!
    
    public init(name: String, imageName: String, major: String, city: String, bio: String){
        self.name = name
        self.imageName = imageName
        self.major = major
        self.city = city
        self.bio = bio
    }
}
