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
    var doctor      : Int? = 0
    var user        : Int? = 0
    
    init(id: Int?, gender: String, dateOfBirth: String, createdAt: String,updatedAt: String, doctor: Int?, user: Int?){
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
        case doctor         = "updated_at"
        case user           = ""
    }
    
    
}
