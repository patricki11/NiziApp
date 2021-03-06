//
//  newFoodMealComponent.swift
//  NiziApp
//
//  Created by Samir Yeasin on 18/11/2020.
//  Copyright © 2020 Samir Yeasin. All rights reserved.
//

import Foundation

class newFoodMealComponent : Codable {
    var id          : Int    = 0
    var name        : String = ""
    var description : String = ""
    var kcal        : Float  = 0.0
    var protein     : Float  = 0.0
    var potassium   : Float  = 0.0
    var sodium      : Float  = 0.0
    var water       : Float  = 0.0
    var fiber       : Float  = 0.0
    var portionSize : Float  = 0.0
    var imageUrl    : String = ""
    var foodId      : Int    = 0
    
    init(id : Int, name: String, description : String, kcal : Float,protein : Float, potassium : Float, sodium: Float, water : Float, fiber: Float, portionSize : Float, imageUrl : String, foodId : Int){
        self.id          = id
        self.name        = name
        self.description = description
        self.kcal        = kcal
        self.protein     = protein
        self.potassium   = potassium
        self.sodium      = sodium
        self.water       = water
        self.fiber       = fiber
        self.portionSize = portionSize
        self.imageUrl    = imageUrl
        self.foodId      = foodId
    }
    
    enum CodingKeys : String, CodingKey {
        case id          = "id"
        case name        = "name"
        case description = "description"
        case kcal        = "kcal"
        case protein     = "protein"
        case potassium   = "potassium"
        case sodium      = "sodium"
        case water       = "water"
        case fiber       = "fiber"
        case portionSize = "portion_size"
        case imageUrl    = "image_url"
        case foodId      = "foodId"
    }
    
    func toJSON() -> [String:Any] {
           return [
            "id"            : id as Any,
            "name"          : name as Any,
            "description"   : description as Any,
            "image_url"     : imageUrl as Any,
            "kcal"          : kcal as Any,
            "protein"       : protein as Any,
            "potassium"     : potassium as Any,
            "sodium"        : sodium as Any,
            "water"         : water as Any,
            "fiber"         : fiber as Any,
            "portion_size"  : portionSize as Any,
            "foodId"        : foodId as Any
           ]
       }
    
    func toNewFoodMealComponentJSON() -> [String:Any] {
        return
        [
            "food_meal_component" :
            [
                "protein"     : protein as Any,
                "id"          : id as Any,
                "sodium"      : sodium as Any,
                "name"        : name as Any,
                "kcal"        : kcal as Any,
                "potassium"   : potassium as Any,
                "water"       : water as Any,
                "description" : description as Any,
                "fiber"       : fiber as Any,
                "image_url"   : imageUrl as Any
            ],
            "name" : name as Any
        ]
    }
}
