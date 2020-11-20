//
//  NewConsumption.swift
//  NiziApp
//
//  Created by Samir Yeasin on 18/11/2020.
//  Copyright © 2020 Samir Yeasin. All rights reserved.
//

import Foundation

class NewConsumption : Codable {
    var id : Int? = 0
    var amount : Float? = 0
    var date : String? = ""
    var mealTime : String? = ""
    var patient : NewPatient? = nil
    var createdAt : String? = ""
    var updatedAt : String? = ""
    var foodMealCompenent : [newFoodMealComponent]? = nil
    
    init(id : Int?, amount : Float?, date : String?, mealTime : String?, newPatient : NewPatient?, createdAt : String?, updatedAt : String?, foodMealComponent : [newFoodMealComponent]? ){
        self.id = id
        self.amount = amount
        self.date = date
        self.mealTime = mealTime
        self.patient = newPatient
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.foodMealCompenent = foodMealComponent
    }
    
    enum CodingKeys : String, CodingKey {
        case id = "id"
        case amount = "amount"
        case date = "date"
        case mealTime = "meal_time"
        case patient = "patient"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case foodMealCompenent = "food_meal_component"
    }
    
    func toJSON() -> [String:Any]{
        return [
            "id"                  : id as Any,
            "amount"              : amount as Any,
            "date"                : date as Any,
            "meal_time"           : mealTime as Any,
            "patient"             : patient as Any,
            "created_at"          : createdAt as Any,
            "updated_at"          : updatedAt as Any,
            "food_meal_component" : foodMealCompenent as Any
        ]
    }
    
    
}

