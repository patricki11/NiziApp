//
//  Meal.swift
//  NiziApp
//
//  Created by Wing lam on 03/12/2019.
//  Copyright © 2019 Samir Yeasin. All rights reserved.
//

/*
import Foundation

class Meal : Codable {
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
    var water : Double = 0.0
    
    init(mealId : Int, name: String, patientId : Int, kCal : Double, protein : Double, fiber : Double, calcium : Double, sodium : Double, portionSize : Double, weightUnit : String, picture : String, water : Double){
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
        self.water = water
    }
    
    enum CodingKeys : String, CodingKey {
         case mealId      = "MealId"
         case name        = "Name"
         case patientId   = "PatientId"
         case kCal        = "KCal"
         case protein     = "Protein"
         case fiber       = "Fiber"
         case calcium     = "Calcium"
         case sodium      = "Sodium"
         case portionSize = "PortionSize"
         case weightUnit  = "WeightUnit"
         case picture     = "Picture"
         case water       = "Water"
     }
    
    func toJSON() -> [String:Any] {
              return [
                  "MealId"      : mealId as Any,
                  "Name"        : name as Any,
                  "PatientId"   : patientId as Any,
                  "KCal"        : kCal as Any,
                  "Protein"     : protein as Any,
                  "Fiber"       : fiber as Any,
                  "Calcium"     : calcium as Any,
                  "Sodium"      : sodium as Any,
                  "PortionSize" : portionSize as Any,
                  "WeightUnit"  : weightUnit as Any,
                  "Picture"     : picture as Any,
                  "Water"       : water as Any
              ]
          }
}
*/
