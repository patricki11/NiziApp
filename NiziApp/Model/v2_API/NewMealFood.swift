//
//  NewMealFood.swift
//  NiziApp
//
//  Created by Samir Yeasin on 09/12/2020.
//  Copyright © 2020 Samir Yeasin. All rights reserved.
//

import Foundation

class NewMealFood : Codable {
    var id : Int = 0
    var amount : Float = 0
    
    init(id : Int, amount : Float){
        self.id = id
        self.amount = amount
    }
    
    enum CodingKeys : String, CodingKey {
        case id = "id"
        case amount = "amount"
    }
}
