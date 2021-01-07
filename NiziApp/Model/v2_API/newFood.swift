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
    var weightObject      : newWeightUnit?     = nil
    var weightId          : Int?               = 0
    var createdAt         : String?            = ""
    var updatedAt         : String?            = ""
    var name              : String?            = ""
    var foodMealComponent : newFoodMealComponent? = nil
    var favoriteFoods     : NewFavoriteShort?  = nil
    var amount            : Float?               = 0
    
    init(id : Int?, weight : Int?, createdAt : String?, updatedAt : String?, name : String?, foodMealComponent : newFoodMealComponent?, weightObject : newWeightUnit?, favoriteFoods : NewFavoriteShort, amount : Float?){
        self.id                = id
        self.weightId          = weight
        self.createdAt         = createdAt
        self.updatedAt         = updatedAt
        self.name              = name
        self.foodMealComponent = foodMealComponent
        self.favoriteFoods     = favoriteFoods
        //self.weightObject      = weightObject
        self.amount            = amount
    }
    
    enum CodingKeys : String, CodingKey {
        case id                = "id"
        case weightId          = "weight_unit"
        case createdAt         = "created_at"
        case updatedAt         = "updated_at"
        case name              = "name"
        case foodMealComponent = "food_meal_component"
        case favoriteFoods     = "my_food"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy:CodingKeys.self)
        
        self.id                       = try container.decode(Int?.self, forKey: .id)
        self.createdAt                = try container.decode(String?.self, forKey: .createdAt)
        self.updatedAt                = try container.decode(String?.self, forKey: .updatedAt)
        self.name                     = try container.decode(String?.self, forKey: .name)
        
        self.weightId                 = try? container.decode(Int?.self, forKey: .weightId)
        self.weightObject             = try? container.decode(newWeightUnit?.self, forKey: .weightId)
        if(weightObject != nil) {
            self.weightId = weightObject?.id
        }
        self.foodMealComponent        = try? container.decode(newFoodMealComponent?.self, forKey: .foodMealComponent)
        self.favoriteFoods            = try? container.decode(NewFavoriteShort?.self, forKey: .favoriteFoods)
    }
}
