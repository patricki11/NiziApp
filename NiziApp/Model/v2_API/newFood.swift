//
//  newFood.swift
//  NiziApp
//
//  Created by Samir Yeasin on 11/11/2020.
//  Copyright © 2020 Samir Yeasin. All rights reserved.
//

import Foundation

class NewFood : Codable {
    var id                : Int?               = 0
    var weight            : newWeightUnit?     = nil
    var createdAt         : String?            = ""
    var updatedAt         : String?            = ""
    var name              : String?            = ""
    var foodMealComponent : newFoodMealComponent? = nil
    
    init(id : Int?, weight : newWeightUnit?, createdAt : String?, updatedAt : String?, name : String?, foodMealComponent : newFoodMealComponent?){
        self.id                = id
        self.weight            = weight
        self.createdAt         = createdAt
        self.updatedAt         = updatedAt
        self.name              = name
        self.foodMealComponent = foodMealComponent
    }
    
    enum CodingKeys : String, CodingKey {
        case id                = "id"
        case weight            = "weight_unit"
        case createdAt         = "created_at"
        case updatedAt         = "updated_at"
        case name              = "name"
        case foodMealComponent = "food_meal_component"
    }
}