//
//  ConsumptionView.swift
//  NiziApp
//
//  Created by Samir Yeasin on 10/12/2019.
//  Copyright © 2019 Samir Yeasin. All rights reserved.
//

import Foundation
import UIKit

class ConsumptionView : Codable {
    var consumptionId : Int    = 0
    var foodName      : String? = ""
    var kcal          : Float?  = nil
    var protein       : Float?  = nil
    var fiber         : Float?  = nil
    var calium        : Float?  = nil
    var sodium        : Float?  = nil
    var amount        : Float?  = nil
    var weight        : Weight? = nil
    var date          : String? = ""
    
    enum CodingKeys : String, CodingKey {
        case consumptionId = "ConsumptionId"
        case foodName      = "FoodName"
        case kcal          = "KCal"
        case protein       = "Protein"
        case fiber         = "Fiber"
        case calium        = "Calium"
        case sodium        = "Sodium"
        case amount        = "Amount"
        case weight        = "Weight"
        case date          = "Date"
       }
}
