//
//  Token.swift
//  NiziApp
//
//  Created by Samir Yeasin on 09/12/2019.
//  Copyright © 2019 Samir Yeasin. All rights reserved.
//

import Foundation

class Token : Codable {
    var scheme     : String? = nil
    var accessCode : String? = nil
    
    enum CodingKeys : String, CodingKey {
        case scheme     = "scheme"
        case accessCode = "accessCode"
    }
}
