//
//  Login.swift
//  NiziApp
//
//  Created by Samir Yeasin on 09/12/2019.
//  Copyright © 2019 Samir Yeasin. All rights reserved.
//

import Foundation

class DoctorLogin : Decodable {
    var account : Account? = nil
    var doctor  : Doctor?  = nil
    var auth    : Auth?    = nil
    
    enum CodingKeys : String, CodingKey {
        case account = "account"
        case doctor  = "doctor"
        case auth    = "auth"
    }
}

class PatientLogin : Encodable, Decodable {
    var account : Account? = nil
    var doctor  : Doctor?  = nil
    var patient : Patient? = nil
    var auth    : Auth?    = nil
    
    enum CodingKeys : String, CodingKey {
        case account = "account"
        case doctor  = "doctor"
        case patient = "patient"
        case auth    = "authLogin"
    }
    
    init(account: Account, doctor: Doctor?, patient: Patient?, auth: Auth?) {
        self.account = account
        self.doctor = doctor
        self.patient = patient
        self.auth = auth
    }
    
    func toJSON() -> [String:Any] {
        return [
            "account": account?.toJSON() as Any,
            "doctor": doctor?.toJSON() as Any,
            "patient": patient?.toJSON() as Any,
            "auth": auth?.toJSON() as Any,
        ]
    }
}
