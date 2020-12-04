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
    var doctorObject : NewDoctor? = nil
    var user        : Int? = 0
    var userObject  : NewUser? = nil
    //TODO: Types aanmaken
    var feedbacks : String? = ""
    var dietaryManagements : String? = ""
    var favoriteFoods : String? = ""
    var consumptions : String? = ""
    
    init(id: Int?, gender: String, dateOfBirth: String, createdAt: String,updatedAt: String, doctor: Int?, user: Int?){
        self.id             = id
        self.gender         = gender
        self.dateOfBirth    = dateOfBirth
        self.createdAt      = createdAt
        self.updatedAt      = updatedAt
        self.doctor         = doctor
        self.user           = user
    }
    
    required init(from decoder: Decoder) throws
    {
        var container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id  = try container.decode(Int.self, forKey: .id)
        self.gender  = try container.decode(String.self, forKey: .gender)
        self.dateOfBirth = try container.decode(String.self, forKey: .dateOfBirth)
        self.createdAt = try container.decode(String.self, forKey: .createdAt)
        self.updatedAt = try container.decode(String.self, forKey: .updatedAt)
        
        self.doctor = try? container.decode(Int?.self, forKey: .doctor)
        self.doctorObject = try? container.decode(NewDoctor?.self, forKey: .doctor)
        if(doctorObject != nil) {
            self.doctor = doctorObject?.id
        }
        
        self.user = try? container.decode(Int?.self, forKey: .user)
        self.userObject = try? container.decode(NewUser?.self, forKey: .user)
        if(userObject != nil) {
            self.user = userObject?.id
        }
        
        //TODO: Type aanpassen wanneer deze gemaakt zijn
        self.feedbacks = try? container.decode(String.self, forKey: .feedbacks)
        self.dietaryManagements = try? container.decode(String.self, forKey: .dietaryManagements)
        self.favoriteFoods = try? container.decode(String.self, forKey: .favoriteFoods)
        self.consumptions = try? container.decode(String.self, forKey: .consumptions)
    }
        
    enum CodingKeys : String, CodingKey {
        case id                 = "id"
        case gender             = "gender"
        case dateOfBirth        = "date_of_birth"
        case createdAt          = "created_at"
        case updatedAt          = "updated_at"
        case doctor             = "doctor"
        case user               = "user"
        case feedbacks          = "feedbacks"
        case dietaryManagements = "dietary_managements"
        case favoriteFoods      = "my_foods"
        case consumptions       = "consumptions"
    }
    
    func toNewPatientJSON() -> [String:Any] {
        return [
            "gender" : gender as Any,
            "date_of_birth" : dateOfBirth as Any,
            "doctor" : doctor as Any
        ]
    }
    
    func toUpdatedPatientJSON() -> [String:Any] {
        return [
            "id" : id as Any,
            "date_of_birth" : dateOfBirth as Any,
        ]
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
