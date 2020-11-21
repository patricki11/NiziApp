//
//  NewUser.swift
//  NiziApp
//
//  Created by Patrick Dammers on 19/10/2020.
//  Copyright © 2020 Samir Yeasin. All rights reserved.
//

import Foundation

class NewUser : Codable {
    var id         : Int? = 0
    var username   : String? = ""
    var email      : String? = ""
    var provider   : String? = ""
    var confirmed  : Bool? = false
    var role       : NewRole? = nil
    var created_at : String? = ""
    var updated_at : String? = ""
    var firstname  : String? = ""
    var lastname   : String? = ""
    var test       : String? = ""
    var patient    : Int? = 0
    var patientObject : NewPatient? = nil
    var first_name : String? = ""
    var last_name  : String? = ""
    var doctor     : Int? = 0
    var doctorObject : NewDoctor? = nil
    
    init(id: Int?, password: String?, username: String?, email: String?, provider: String?, confirmed: Bool?, role: NewRole, created_at: String?, updated_at: String?, firstname: String?, lastname: String?, test: String?, patient: Int?, first_name: String?, last_name: String?, doctor: Int?) {
        self.id         = id
        self.username   = username
        self.email      = email
        self.provider   = provider
        self.confirmed  = confirmed
        self.role       = role
        self.created_at = created_at
        self.updated_at = updated_at
        self.firstname  = firstname
        self.lastname   = lastname
        self.test       = test
        self.patient    = patient
        self.first_name = first_name
        self.last_name  = last_name
        self.doctor     = doctor
    }
    
    required init(from decoder: Decoder) throws {
        print("Test")
        
        let container = try decoder.container(keyedBy:CodingKeys.self)
        print("Test Container Parsed")
        
        self.id = try container.decode(Int?.self, forKey: .id)
        print("id")
        self.username = try container.decode(String?.self, forKey: .username)
        print("username")
        self.email = try container.decode(String?.self, forKey: .email)
        print("email")
        self.provider = try container.decode(String?.self, forKey: .provider)
        print("provider")
        self.confirmed = try container.decode(Bool?.self, forKey: .confirmed)
        print("confirmed")
        self.role = try container.decode(NewRole?.self, forKey: .role)
        print("role")
        self.created_at = try container.decode(String?.self, forKey: .created_at)
        print("created_at")
        self.firstname = try container.decode(String?.self, forKey: .firstname)
        print("firstname")
        self.lastname = try container.decode(String?.self, forKey: .lastname)
        print("lastname")
        self.test = try container.decode(String?.self, forKey: .test)
        print("test")
        self.first_name = try container.decode(String?.self, forKey: .first_name)
        print("first_name")
        self.last_name = try container.decode(String?.self, forKey: .last_name)
        print("last_name")
        
        print("Test Start patient")
        self.patient = try? container.decode(Int?.self, forKey: .patient)
        print("Test Start patientObject")
        self.patientObject = try? container.decode(NewPatient?.self, forKey: .patient)
        print("Test Start doctor")
        self.doctor = try? container.decode(Int?.self, forKey: .doctor)
        print("Test Start doctorObject")
        self.doctorObject = try? container.decode(NewDoctor?.self, forKey: .doctor)
    }
    
    enum CodingKeys : String, CodingKey {
        case id         = "id"
        case username   = "username"
        case email      = "email"
        case provider   = "provider"
        case confirmed  = "confirmed"
        case role       = "role"
        case created_at = "created_at"
        case firstname  = "firstname"
        case lastname   = "lastname"
        case test       = "test"
        case patient    = "patient"
        case first_name = "first_name"
        case last_name  = "last_name"
        case doctor     = "doctor"
    }
    
    func toJSON() -> [String:Any] {
        return [
            "id"         : id as Any,
            "username"   : username as Any,
            "email"      : email as Any,
            "provider"   : provider as Any,
            "confirmed"  : confirmed as Any,
            "role"       : role as Any,
            "created_at" : created_at as Any,
            "firstname"  : firstname as Any,
            "lastname"   : lastname as Any,
            "test"       : test as Any,
            "patient"    : patient as Any,
            "first_name" : first_name as Any,
            "last_name"  : last_name as Any,
            "doctor"     : doctor as Any,
        ]
    }
}
