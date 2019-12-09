//
//  Account.swift
//  NiziApp
//
//  Created by Samir Yeasin on 09/12/2019.
//  Copyright © 2019 Samir Yeasin. All rights reserved.
//

import Foundation

class Account : Codable {
    var accountId : Int = 0
    var role      : String = ""
    
    enum CodingKeys : String, CodingKey {
        case accountId = "accountId"
        case role      = "role"
    }
}
