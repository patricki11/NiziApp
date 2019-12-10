//
//  Weight.swift
//  NiziApp
//
//  Created by Wing lam on 10/12/2019.
//  Copyright © 2019 Samir Yeasin. All rights reserved.
//

import Foundation
import UIKit

class Weight : Codable {
    var id      : Int    = 0
    var unit    : String = ""
    var short   : String = ""
    
    enum CodingKeys : String, CodingKey {
        case id    = "Id"
        case unit  = "Unit"
        case short = "Short"
    }
}
