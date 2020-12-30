//
//  Auth.swift
//  NiziApp
//
//  Created by Patrick Dammers on 09/12/2019.
//  Copyright © 2019 Patrick Dammers. All rights reserved.
//
/*
import Foundation

class Auth : Codable {
    var guid  : String? = nil
    var token : Token? = nil
    
    enum CodingKeys : String, CodingKey {
        case guid  = "guid"
        case token = "token"
    }
    
    init(guid: String?, token: Token?) {
        self.guid = guid
        self.token = token
    }
    
    func toJSON() -> [String:Any] {
        return [
            "guid": guid as Any,
            "token": token?.toJSON() as Any
        ]
    }
}
*/
