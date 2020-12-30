//
//  Patient.swift
//  NiziApp
//
//  Created by Samir Yeasin on 29/11/2019.
//  Copyright © 2019 Samir Yeasin. All rights reserved.
//

import Foundation

class Patient : Codable {
    var patientId   : Int? = 0
    var accountId   : Int? = 0
    var doctorId    : Int? = 0
    var firstName   : String? = ""
    var lastName    : String? = ""
    var dateOfBirth : String? = ""
    var weightInKg  : Float? = Float()
    var guid        : String? = ""
    
    init(patientId: Int?, accountId: Int?, doctorId: Int?, firstName: String?, lastName: String?, dateOfBirth: String?, guid: String?, weightInKg: Float?  ){
        
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
        case weightInKg  = "weightInKilograms"
        case guid        = "guid"
    }
    
    func toJSON() -> [String:Any] {
        return [
            "firstName": firstName as Any,
            "lastName": lastName as Any,
            "dateOfBirth": dateOfBirth as Any,
            "weight": weightInKg as Any,
            "doctorId": doctorId as Any
        ]
    }
}

class PatientPersonalInfo : Codable {
    var patientId   : Int? = 0
    var doctorId    : Int? = 0
    var firstName   : String? = ""
    var lastName    : String? = ""
    var dateOfBirth : String? = ""
    var weightInKg  : Float? = Float()
    
    enum CodingKeys : String, CodingKey {
        case patientId   = "PatientId"
        case doctorId    = "HandlingDoctorId"
        case firstName   = "FirstName"
        case lastName    = "LastName"
        case dateOfBirth = "DateOfBirth"
        case weightInKg  = "WeightInKilograms"
    }
    
    func toJSON() -> [String:Any] {
        return [
            "PatientId"        : patientId as Any,
            "HandlingDoctorId" : doctorId as Any,
            "firstName"        : firstName as Any,
            "lastName"         : lastName as Any,
            "dateOfBirth"      : dateOfBirth as Any,
            "weight"           : weightInKg as Any,
            "doctorId"         : doctorId as Any
        ]
    }
}



