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
    var role       : Int? = 0
    var roleObject : NewRole? = nil
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
    
    init(id: Int?, password: String?, username: String?, email: String?, provider: String?, confirmed: Bool?, role: Int?, created_at: String?, updated_at: String?, firstname: String?, lastname: String?, test: String?, patient: Int?, first_name: String?, last_name: String?, doctor: Int?) {
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
        let container = try decoder.container(keyedBy:CodingKeys.self)
        
        self.id = try container.decode(Int?.self, forKey: .id)
        self.username = try container.decode(String?.self, forKey: .username)
        self.email = try container.decode(String?.self, forKey: .email)
        self.provider = try container.decode(String?.self, forKey: .provider)
        self.confirmed = try container.decode(Bool?.self, forKey: .confirmed)
        
        self.role = try? container.decode(Int?.self, forKey: .role)
        self.roleObject = try? container.decode(NewRole?.self, forKey: .role)
        if(roleObject != nil) {
            self.role = roleObject?.id
        }
        
        self.created_at = try container.decode(String?.self, forKey: .created_at)
        self.firstname = try container.decode(String?.self, forKey: .firstname)
        self.lastname = try container.decode(String?.self, forKey: .lastname)
        self.test = try container.decode(String?.self, forKey: .test)
        self.first_name = try container.decode(String?.self, forKey: .first_name)
        self.last_name = try container.decode(String?.self, forKey: .last_name)
        
        self.patient = try? container.decode(Int?.self, forKey: .patient)
        self.patientObject = try? container.decode(NewPatient?.self, forKey: .patient)
        if(patientObject != nil) {
            self.patient = patientObject?.id
        }
        
        self.doctor = try? container.decode(Int?.self, forKey: .doctor)
        self.doctorObject = try? container.decode(NewDoctor?.self, forKey: .doctor)
        
        if(doctorObject != nil) {
            self.doctor = doctorObject?.id
        }
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
