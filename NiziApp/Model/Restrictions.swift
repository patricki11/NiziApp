//
//  Restrictions.swift
//  NiziApp
//
//  Created by Samir Yeasin on 03/01/2020.
//  Copyright © 2020 Samir Yeasin. All rights reserved.
//

import Foundation

class Restrictions : Codable {
    var id              : Int?    = 0
    var description     : String? = ""
   
    init(id: Int, description: String) {
        self.id = id
        self.description = description
    }
    
    enum CodingKeys : String, CodingKey {
        case id          = "id"
        case description = "Description"
    }
}
