//
//  Patient.swift
//  NiziApp
//
//  Created by Samir Yeasin on 11/11/2020.
//  Copyright © 2020 Samir Yeasin. All rights reserved.
//

import Foundation

class Patient : Codable {
    var id : Int? = 0
    var gender : String = ""
    var dateOfBirth : String = ""
    var createdAt : String = ""
    var doctor : Int = 0
    var user : Int = 0
    
    init(id: Int?, gender: String, dateOfBirth: String, createdAt: String, doctor: Int?, user: Int?){
        
    }
    
    
}
