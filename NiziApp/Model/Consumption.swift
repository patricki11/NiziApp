//
//  Consumption.swift
//  NiziApp
//
//  Created by Wing lam on 03/12/2019.
//  Copyright © 2019 Samir Yeasin. All rights reserved.
//

import Foundation

class Consumption {
    var foodName: String = ""
    var kCal : Float = Float()    
    var protein : Float = Float()
    var fiber : Float = Float()
    var calium : Float = Float()
    var sodium : Float = Float()
    var amount : Int = 0
    var weightUnitId : Float = Float()
    var date : String = ""
    var patientId : Int = 0
    var id : Int = 0
    
    init(foodName : String, kCal : Float, protein : Float, fiber: Float, calium: Float, sodium : Float, amount : Int, weightUnitId : Float, date : String, patientId : Int, id : Int){
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
    }
}
