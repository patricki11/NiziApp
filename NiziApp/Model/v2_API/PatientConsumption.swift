//
//  PatientConsumption.swift
//  NiziApp
//
//  Created by Samir Yeasin on 07/12/2020.
//  Copyright © 2020 Samir Yeasin. All rights reserved.
//

import Foundation

class PatientConsumption : Codable {
    var id : Int = 0
    
    init(id: Int) {
        self.id = id
    }
    
    enum CodingKeys : String, CodingKey {
        case id = "id"
    }
    
    func toJSON() -> [String:Any]{
        return [
            "id" : id as Any
        ]
    }
}
