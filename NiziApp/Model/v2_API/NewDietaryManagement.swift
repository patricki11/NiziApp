//
//  NewDietaryManagement.swift
//  NiziApp
//
//  Created by Patrick Dammers on 23/11/2020.
//  Copyright © 2020 Samir Yeasin. All rights reserved.
//

import Foundation

class NewDietaryManagement : Codable {
    var id                       : Int? = 0
    var is_active                : Bool = false
    var dietaryRestriction        : Int? = 0
    var dietaryRestrictionObject : NewDietaryRestriction? = nil
    var patient                  : Int? = 0
    var patientObject            : NewPatient? = nil
    var created_at               : String? = ""
    var updated_at               : String? = ""
    var minimum                  : Int? = 0
    var maximum                  : Int? = 0

    init(id: Int?, isActive: Bool, dietaryRestriction: Int?, patient: Int?, createdAt: String?, updatedAt: String?, minimum: Int?, maximum: Int?) {
        self.id                 = id
        self.is_active          = isActive
        self.dietaryRestriction = dietaryRestriction
        self.patient            = patient
        self.created_at         = createdAt
        self.updated_at         = updatedAt
        self.minimum            = minimum
        self.maximum            = maximum
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy:CodingKeys.self)
        
        self.id                       = try container.decode(Int?.self, forKey: .id)
        self.is_active                = try container.decode(Bool.self, forKey: .is_active)
        
        self.dietaryRestriction       = try container.decode(Int?.self, forKey: .dietaryRestriction)
        self.dietaryRestrictionObject = try container.decode(NewDietaryRestriction?.self, forKey: .dietaryRestriction)
        if(dietaryRestrictionObject != nil) {
            self.dietaryRestriction = dietaryRestrictionObject?.id
        }
        
        self.patient                  = try container.decode(Int?.self, forKey: .patient)
        self.patientObject            = try container.decode(NewPatient.self, forKey: .patient)
        if(patientObject != nil) {
            self.patient = patientObject?.id
        }
        
        self.created_at               = try container.decode(String?.self, forKey: .created_at)
        self.updated_at               = try container.decode(String?.self, forKey: .updated_at)
        self.minimum                  = try container.decode(Int?.self, forKey: .minimum)
        self.maximum                  = try container.decode(Int?.self, forKey: .maximum)
    }
    
    enum CodingKeys : String, CodingKey {
        case id                 = "id"
        case is_active          = "is_active"
        case dietaryRestriction = "dietary_restriction"
        case patient            = "patient"
        case created_at         = "created_at"
        case updated_at         = "updated_at"
        case minimum            = "minimum"
        case maximum            = "maximum"
    }
}

