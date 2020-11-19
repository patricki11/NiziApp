//
//  Patient.swift
//  NiziApp
//
//  Created by Samir Yeasin on 11/11/2020.
//  Copyright © 2020 Samir Yeasin. All rights reserved.
//

import Foundation

class NewPatient : Codable {
    var id          : Int? = 0
    var gender      : String = ""
    var dateOfBirth : String = ""
    var createdAt   : String = ""
    var updatedAt   : String = ""
    var doctor      : NewDoctor?
    var user        : NewUser?
    
    init(id: Int?, gender: String, dateOfBirth: String, createdAt: String,updatedAt: String, doctor: NewDoctor?, user: NewUser){
        self.id             = id
        self.gender         = gender
        self.dateOfBirth    = dateOfBirth
        self.createdAt      = createdAt
        self.updatedAt      = updatedAt
        self.doctor         = doctor
        self.user           = user
    }
    
    enum CodingKeys : String, CodingKey {
        case id             = "id"
        case gender         = "gender"
        case dateOfBirth    = "date_of_birth"
        case createdAt      = "created_at"
        case updatedAt      = "updated_at"
        case doctor         = "doctor"
        case user           = "user"
    }
    
    func toJSON() -> [String:Any]{
        return [
            "id"            : id as Any,
            "gender"        : gender as Any,
            "date_of_birth" : dateOfBirth as Any,
            "created_at"    : createdAt as Any,
            "updated_at"    : updatedAt as Any,
            "doctor"        : doctor as Any,
            "user"          : user as Any
        ]
    }
}
