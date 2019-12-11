//
//  Food.swift
//  NiziApp
//
//  Created by Wing lam on 03/12/2019.
//  Copyright © 2019 Samir Yeasin. All rights reserved.
//

import Foundation

class Food : Codable {
    var foodId      : Int    = 0
    var name        : String = ""
    var kCal        : Double = 0.0
    var protein     : Double = 0.0
    var fiber       : Double = 0.0
    var calcium     : Double = 0.0
    var sodium      : Double = 0.0
    var portionSize : Double = 0.0
    var weightUnit  : String = ""
    var picture     : String = ""
    
    init(foodId : Int, name : String, kCal : Double, protein : Double, fiber : Double, calcium : Double, sodium : Double, portionSize : Double, weigtUnit : String, picture : String){
        
        self.foodId = foodId
        self.name = name
        self.kCal = kCal
        self.protein = protein
        self.fiber = fiber
        self.calcium = calcium
        self.sodium = sodium
        self.portionSize = portionSize
        self.weightUnit = weigtUnit
        self.picture = picture
    }
    
    enum CodingKeys : String, CodingKey {
        case foodId      = "FoodId"
        case name        = "Name"
        case kCal        = "KCal"
        case protein     = "Protein"
        case fiber       = "Fiber"
        case calcium     = "Calcium"
        case sodium      = "Sodium"
        case portionSize = "PortionSize"
        case weightUnit  = "WeightUnit"
        case picture     = "Picture"
    }
}
