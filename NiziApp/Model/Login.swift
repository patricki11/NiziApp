//
//  Login.swift
//  NiziApp
//
//  Created by Samir Yeasin on 09/12/2019.
//  Copyright © 2019 Samir Yeasin. All rights reserved.
//

import Foundation

class DoctorLogin : Decodable {
    var account : Account  = Account()
    var doctor  : Doctor?  = nil
    var auth    : Auth?    = nil
    
    enum CodingKeys : String, CodingKey {
        case account = "account"
        case doctor  = "doctor"
        case auth    = "auth"
    }
}

class PatientLogin : Decodable {
    var account : Account  = Account()
    var doctor  : Doctor?  = nil
    var patient : Patient? = nil
    var auth    : Auth?    = nil
    
    enum CodingKeys : String, CodingKey {
        case account = "account"
        case doctor  = "doctor"
        case patient = "patient"
        case auth    = "authLogin"
    }
}
