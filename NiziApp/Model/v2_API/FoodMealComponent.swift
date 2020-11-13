//
//  FoodMealComponent.swift
//  NiziApp
//
//  Created by Samir Yeasin on 13/11/2020.
//  Copyright © 2020 Samir Yeasin. All rights reserved.
//

import Foundation

class FoodMealComponent : Codable {
    var id          : Int? = 0
    var name        : String? = ""
    var description : String? = ""
    var kcal        : Float? = 0.0
    var protein     : Float? = 0.0
    var potassium   : Float? = 0.0
    var sodium      : Float? = 0.0
    var water       : Float? = 0.0
    var fiber       : Float? = 0.0
    var portionSize : Float? = 0.0
    var image       : String? = ""
    
    init(id : Int?, name : String?, description : String?, kcal : Float? , protein : Float?, potassium : Float, sodium : Float, water : Float?, fiber : Float?, portionSize : Float, image : String?){
        
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
        self.image       = image
    }
    
    enum CodingKeys : String, CodingKey{
        case id = "id"
        case name = "name"
        case description = "description"
        case kcal = "kcal"
        case protein = "protein"
        case potassium = "potassium"
        case sodium = "sodium"
        case water = "water"
        case fiber = "fiber"
        case portionSize = "portion_size"
        case image = "image"
    }
    
}
