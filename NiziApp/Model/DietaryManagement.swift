//
//  DietaryManagement.swift
//  NiziApp
//
//  Created by Wing lam on 03/12/2019.
//  Copyright © 2019 Samir Yeasin. All rights reserved.
//

import Foundation

class DietaryManagement{
    var id          : Int = 0
    var description : String = ""
    var amount      : Int = 0
    var isActive    : Bool = false
    var patientId   : Int = 0

    init(id : Int, description : String, amount : Int, isActive : Bool, patientId : Int ){
        self.id = id
        self.description = description
        self.amount = amount
        self.isActive = isActive
        self.patientId = patientId
    }
}
