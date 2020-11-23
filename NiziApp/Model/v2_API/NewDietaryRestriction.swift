//
//  NewDietaryRestriction.swift
//  NiziApp
//
//  Created by Patrick Dammers on 23/11/2020.
//  Copyright © 2020 Samir Yeasin. All rights reserved.
//

import Foundation
class NewDietaryRestriction : Codable {
    var id         : Int? = 0
    var description   : String? = ""
    var created_at : String? = ""
    var updated_at : String? = ""
    var plural  : String? = ""
    var weightUnit : Int? = 0
    var weightUnitObject   : newWeightUnit? = nil
    
    init(id: Int?, password: String?, description: String?, created_at: String?, updated_at: String?, plural: String?, weightUnit	: Int?) {
        self.id          = id
        self.description = description
        self.created_at  = created_at
        self.updated_at  = updated_at
        self.plural      = plural
        self.weightUnit  = weightUnit
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy:CodingKeys.self)
        
        self.id = try container.decode(Int?.self, forKey: .id)
        self.description = try container.decode(String?.self, forKey: .description)
        self.created_at = try container.decode(String?.self, forKey: .created_at)
        self.updated_at = try container.decode(String?.self, forKey: .updated_at)
        self.plural = try container.decode(String?.self, forKey: .plural)
        
        self.weightUnit = try? container.decode(Int?.self, forKey: .weightUnit)
        self.weightUnitObject = try? container.decode(newWeightUnit.self, forKey: .weightUnit)
        if(weightUnitObject != nil) {
            self.weightUnit = weightUnitObject?.id
        }
    }
    
    enum CodingKeys : String, CodingKey {
        case id          = "id"
        case description = "description"
        case created_at  = "created_at"
        case updated_at  = "updated_at"
        case plural      = "plural"
        case weightUnit  = "weightUnit"
    }
}
