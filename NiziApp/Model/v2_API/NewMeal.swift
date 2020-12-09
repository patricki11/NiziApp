//
//  NewMeal.swift
//  NiziApp
//
//  Created by Samir Yeasin on 09/12/2020.
//  Copyright © 2020 Samir Yeasin. All rights reserved.
//

import Foundation

class NewMeal : Codable {
    var id                : Int = 0
    var weightUnit        : newWeightUnit
    var patient           : NewPatient
    var foodMealComponent : newFoodMealComponent
    
    init(id : Int, weightUnit : newWeightUnit, patient : NewPatient, foodMealComponent : newFoodMealComponent){
        self.id                = id
        self.weightUnit        = weightUnit
        self.patient           = patient
        self.foodMealComponent = foodMealComponent
    }
    
    enum CodingKeys : String, CodingKey {
        case id                = "id"
        case weightUnit        = "weight_unit"
        case patient           = "patient"
        case foodMealComponent = "food_meal_component"
    }
}
