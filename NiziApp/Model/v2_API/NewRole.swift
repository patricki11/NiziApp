//
//  NewRole.swift
//  NiziApp
//
//  Created by Samir Yeasin on 11/11/2020.
//  Copyright © 2020 Samir Yeasin. All rights reserved.
//

import Foundation

class NewRole : Codable {
    var id          : Int? = 0
    var name        : String? = ""
    var description : String? = ""
    var type        : String? = ""
    
    init(id : Int?, name: String?, description : String?, type : String?){
        self.id          = id
        self.name        = name
        self.description = description
        self.type        = type
    }
    
    enum CodingKeys : String, CodingKey {
        case id             = "id"
        case name           = "name"
        case description    = "description"
        case type           = "type"
    }
    
    func toJSON() -> [String:Any]{
        return [
            "id" : id as Any
        ]
    }

}
