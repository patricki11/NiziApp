//
//  NewFavorite.swift
//  NiziApp
//
//  Created by Samir Yeasin on 23/11/2020.
//  Copyright © 2020 Samir Yeasin. All rights reserved.
//

import Foundation

class NewFavorite : Codable {
    var id : Int? = 0
    var food : NewFood? = nil
    var createdAt : String? = ""
    var updatedAt : String? = ""
    var patients : [NewPatient]? = nil
    
    init(id : Int?, food : NewFood?, createdAt : String?, updatedAt : String?, patients : [NewPatient]?){
        self.id = id
        self.food = food
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.patients = patients
    }
    
    enum CodingKeys : String, CodingKey {
        case id = "id"
        case food = "food"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case patients = "patients_ids"
    }
    
    func toJSON() -> [String:Any]{
        return [
            "id"           : id as Any,
            "food"         : food as Any,
            "created_at"   : createdAt as Any,
            "updated_at"   : updatedAt as Any,
            "patients_ids" : patients as Any
        ]
    }
}
