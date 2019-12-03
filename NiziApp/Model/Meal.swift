//
//  Meal.swift
//  NiziApp
//
//  Created by Wing lam on 03/12/2019.
//  Copyright © 2019 Samir Yeasin. All rights reserved.
//

import Foundation

class Meal {
    var mealId : Int = 0
    var name : String = ""
    var patientId : Int = 0
    var kCal : Double = 0.0
    var protein : Double = 0.0
    var fiber : Double = 0.0
    var calcium : Double = 0.0
    var sodium : Double = 0.0
    var portionSize : Double = 0.0
    var weightUnit : String = ""
    var picture : String = ""
    
    init(mealId : Int, name: String, patientId : Int, kCal : Double, protein : Double, fiber : Double, calcium : Double, sodium : Double, portionSize : Double, weightUnit : String, picture : String){
        self.mealId = mealId
        self.name = name
        self.patientId = patientId
        self.kCal = kCal
        self.protein = protein
        self.fiber = fiber
        self.calcium = calcium
        self.sodium = sodium
        self.portionSize = portionSize
        self.weightUnit = weightUnit
        self.picture = picture
    }
}
