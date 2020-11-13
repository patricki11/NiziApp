//
//  NewUser.swift
//  NiziApp
//
//  Created by Patrick Dammers on 19/10/2020.
//  Copyright © 2020 Samir Yeasin. All rights reserved.
//

import Foundation

class NewUserLogin : Codable {
    var jwt  : String? = ""
    var user : NewUser
    
    init(jwt: String?, user: NewUser) {
        self.jwt  = jwt
        self.user
            = user
    }
    
    enum CodingKeys : String, CodingKey {
        case jwt    = "jwt"
        case user   = "user"
    }
    
    func toJSON() -> [String:Any] {
        return [
            "jwt"  : jwt as Any,
            "user" : user as Any,
        ]
    }
}
