//
//  NewConsumptionModel.swift
//  NiziApp
//
//  Created by Samir Yeasin on 07/12/2020.
//  Copyright © 2020 Samir Yeasin. All rights reserved.
//

import Foundation

class NewConsumptionModel : Codable {
    var amount            : Float = 0
    var date              : String = ""
    var mealTime          : String = ""
    var weightUnit        : newWeightUnit
    var foodmealComponent : newFoodMealComponent
    var patient           : PatientConsumption
    
    init(amount : Float, date : String, mealTime : String, weightUnit : newWeightUnit, foodmealComponent : newFoodMealComponent, patient : PatientConsumption ){
        self.amount = amount
        self.date = date
        self.mealTime = mealTime
        self.foodmealComponent = foodmealComponent
        self.weightUnit = weightUnit
        self.patient = patient
    }
    
    enum CodingKeys : String, CodingKey {
        case amount = "amount"
        case date = "date"
        case mealTime = "meal_time"
        case patient = "patient"
        case weightUnit = "weight_unit"
        case foodmealComponent = "food_meal_component"
    }
    
    func toJSON() -> [String:Any]{
        return [
            "amount"              : amount as Any,
            "date"                : date as Any,
            "meal_time"           : mealTime as Any,
            "patient"             : patient as Any,
            "weight_unit"         : weightUnit as Any,
            "food_meal_component" : foodmealComponent as Any
        ]
    }
}
