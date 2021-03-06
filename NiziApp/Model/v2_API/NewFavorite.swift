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
    var patients : NewPatient? = nil
    
    init(id : Int?, food : NewFood?, patients : NewPatient?){
        self.id = id
        self.food = food
        self.patients = patients
    }
    
    enum CodingKeys : String, CodingKey {
        case id        = "id"
        case food      = "food"
        case patients  = "patients_id"
    }
    
    func toJSON() -> [String:Any]{
        return [
            "id"           : id as Any,
            "food"         : food as Any,
            "patients_id"  : patients as Any
        ]
    }
}
