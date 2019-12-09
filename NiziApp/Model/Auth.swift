//
//  Auth.swift
//  NiziApp
//
//  Created by Patrick Dammers on 09/12/2019.
//  Copyright © 2019 Patrick Dammers. All rights reserved.
//

import Foundation

class Auth : Codable {
    var guid  : String = ""
    var token : Token? = nil
    
    enum CodingKeys : String, CodingKey {
        case guid  = "guid"
        case token = "token"
    }
}
