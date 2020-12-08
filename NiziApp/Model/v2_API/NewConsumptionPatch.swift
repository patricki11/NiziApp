//
//  NewConsumptionPatch.swift
//  NiziApp
//
//  Created by Samir Yeasin on 08/12/2020.
//  Copyright © 2020 Samir Yeasin. All rights reserved.
//

import Foundation

class NewConsumptionPatch {
    var amount            : Float = 0
    var date              : String = ""
    var mealTime          : String = ""
    
    init(amount : Float, date: String, mealTime : String){
        self.amount = amount
        self.date = date
        self.mealTime = mealTime
    }
}
