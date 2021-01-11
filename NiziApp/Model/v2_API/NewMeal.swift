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
    var mealFoods         : [NewMealFood]
    
    init(id : Int, weightUnit : newWeightUnit, patient : NewPatient, foodMealComponent : newFoodMealComponent, mealFoods : [NewMealFood]){
        self.id                = id
        self.weightUnit        = weightUnit
        self.patient           = patient
        self.foodMealComponent = foodMealComponent
        self.mealFoods         = mealFoods
    }
    
    enum CodingKeys : String, CodingKey {
        case id                = "id"
        case weightUnit        = "weight_unit"
        case patient           = "patient"
        case foodMealComponent = "food_meal_component"
        case mealFoods         = "meal_foods"
    }
    
    func toNewMealJSON(forPatient patientId: Int) -> [String:Any] {
        return [
            "patient":
            [
                "id": patientId
            ],
            "weight_unit":
            [
                "id": weightUnit.id
            ],
            "food_meal_component":
            [
                "foodId": foodMealComponent.foodId,
                "protein": foodMealComponent.protein,
                "id": foodMealComponent.id,
                "sodium": foodMealComponent.sodium,
                "name": foodMealComponent.name,
                "kcal":  foodMealComponent.kcal,
                "potassium": foodMealComponent.potassium,
                "water": foodMealComponent.water,
                "description": foodMealComponent.description,
                "fiber": foodMealComponent.fiber,
                "image_url": foodMealComponent.imageUrl,
                "portion_size": foodMealComponent.portionSize
            ],
            "name": foodMealComponent.name
        ]
    }
}
