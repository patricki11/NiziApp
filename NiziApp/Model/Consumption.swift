//
//  Consumption.swift
//  NiziApp
//
//  Created by Wing lam on 03/12/2019.
//  Copyright © 2019 Samir Yeasin. All rights reserved.
//

import Foundation

class Consumption {
    var foodName    : String = ""
    var kCal        : Double = 0.0
    var protein     : Double = 0.0
    var fiber       : Double = 0.0
    var calium      : Double = 0.0
    var sodium      : Double = 0.0
    var water       : Double = 0.0
    var amount      : Int = 0
    var weightUnitId: Double = 0.0
    var date        : String = ""
    var patientId   : Int = 0
    var id          : Int = 0
    
    init(foodName : String, kCal : Double, protein : Double, fiber: Double, calium: Double, sodium : Double, amount : Int, weightUnitId : Double, date : String, patientId : Int, id : Int, water : Double){
        self.foodName = foodName
        self.kCal = kCal
        self.protein = protein
        self.fiber = fiber
        self.calium = calium
        self.sodium = sodium
        self.amount = amount
        self.weightUnitId = weightUnitId
        self.date = date
        self.patientId = patientId
        self.id = id
        self.water = water
    }
    
    func toJSON() -> [String:Any] {
           return [
               "FoodName"    : foodName as Any,
               "KCal"        : kCal as Any,
               "Protein"     : protein as Any,
               "Fiber"       : fiber as Any,
               "Calium"      : calium as Any,
               "Sodium"      : sodium as Any,
               "Amount"      : amount as Any,
               "WeightUnitId": weightUnitId as Any,
               "Date"        : date as Any,
               "PatientId"   : patientId as Any,
               "Id"          : id as Any,
               "Water"       : water as Any
                
           ]
       }
}
