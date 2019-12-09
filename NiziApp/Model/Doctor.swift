//
//  Doctor.swift
//  NiziApp
//
//  Created by Wing lam on 03/12/2019.
//  Copyright © 2019 Samir Yeasin. All rights reserved.
//

import Foundation

class Doctor : Codable{
    var doctorId  : Int = 0
    var firstName : String = ""
    var lastName  : String = ""
    var location  : String = ""
    
    enum CodingKeys : String, CodingKey {
        case doctorId  = "doctorId"
        case firstName = "firstName"
        case lastName  = "lastName"
        case location  = "location"
    }
}
