//
//  NewFavoriteShort.swift
//  NiziApp
//
//  Created by Samir Yeasin on 13/12/2020.
//  Copyright © 2020 Samir Yeasin. All rights reserved.
//

import Foundation

class NewFavoriteShort : Codable {
    var id : Int = 0
    var food : Int = 0
    
    init(id : Int, food : Int){
        self.id = id
        self.food = food
    }
    
    enum CodingKeys : String, CodingKey {
        case id            = "id"
        case food          = "food"
    }
}
