//
//  ConsumptionView.swift
//  NiziApp
//
//  Created by Wing lam on 10/12/2019.
//  Copyright © 2019 Samir Yeasin. All rights reserved.
//

import Foundation
import UIKit

class Diary : Decodable{
    var consumptions    : [ConsumptionView] = []
    
    var kcalTotal       : Float         = Float()
    var proteinTotal    : Float         = Float()
    var fiberTotal      : Float         = Float()
    var caliumTotal     : Float         = Float()
    var sodiumTotal     : Float         = Float()
    
    enum CodingKeys : String, CodingKey {
        case consumptions   = "Consumptions"
        case kcalTotal      = "KCalTotal"
        case proteinTotal   = "ProteinTotal"
        case fiberTotal     = "FiberTotal"
        case caliumTotal    = "CaliumTotal"
        case sodiumTotal    = "sodiumTotal"
     }
    
    
}

