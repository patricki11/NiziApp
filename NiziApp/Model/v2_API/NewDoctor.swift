//
//  NewDoctor.swift
//  NiziApp
//
//  Created by Patrick Dammers on 19/10/2020.
//  Copyright © 2020 Samir Yeasin. All rights reserved.
//

import Foundation

class NewDoctor : Codable {
    var id         : Int? = 0
    var location   : String? = ""
    var updated_at : String = ""
    var created_at : String = ""
    var user       : Int? = 0
    
    init(id: Int, location: String, updated_at: String, created_at: String, user: Int) {
        self.id         = id
        self.location   = location
        self.updated_at = updated_at
        self.created_at = created_at
        self.user       = user
    }
    
    enum CodingKeys : String, CodingKey {
        case id         = "id"
        case location   = "location"
        case updated_at = "updated_at"
        case created_at = "created_at"
        case user       = "user"
    }
    
    func toJSON() -> [String:Any] {
        return [
            "id"         : id as Any,
            "location"   : location as Any,
            "updated_at" : updated_at as Any,
            "created_at" : created_at as Any,
            "user"       : user as Any
        ]
    }
}
