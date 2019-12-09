//
//  Patient.swift
//  NiziApp
//
//  Created by Samir Yeasin on 29/11/2019.
//  Copyright © 2019 Samir Yeasin. All rights reserved.
//

import Foundation

class Patient : Codable {
    var patientId   : Int = 0
    var accountId   : Int = 0
    var doctorId    : Int = 0
    var firstName   : String = ""
    var lastName    : String = ""
    var dateOfBirth : Date = Date()
    var weightInKg  : Float = Float()
    var guid        : String = ""
    
    init(patientId: Int, accountId: Int, doctorId: Int, firstName: String, lastName: String, dateOfBirth: Date, guid: String,  weightInKg: Float  ){
        
        self.patientId   = patientId
        self.accountId   = accountId
        self.doctorId    = doctorId
        self.firstName   = firstName
        self.lastName    = lastName
        self.dateOfBirth = dateOfBirth
        self.weightInKg  = weightInKg
        self.guid        = guid
        
    }
    
    enum CodingKeys : String, CodingKey {
        case patientId   = "patientId"
        case accountId   = "accountId"
        case doctorId    = "doctorId"
        case firstName   = "firstName"
        case lastName    = "lastName"
        case dateOfBirth = "dateOfBirth"
        case weightInKg  = "weightInKg"
        case guid        = "guid"
    }
}
