//
//  newWeightUnit.swift
//  NiziApp
//
//  Created by Samir Yeasin on 18/11/2020.
//  Copyright © 2020 Samir Yeasin. All rights reserved.
//

import Foundation

class newWeightUnit : Codable {
    var id : Int = 0
    var unit : String = ""
    var short : String = ""
    var createdAt : String = ""
    var updatedAt : String = ""
    
    init(id : Int, unit : String, short : String, createdAt : String, updatedAt : String){
        self.id = id
        self.unit = unit
        self.short = short
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    enum CodingKeys : String, CodingKey {
        case id = "id"
        case unit = "unit"
        case short = "short"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    
    
}
