//
//  Doctor.swift
//  NiziApp
//
//  Created by Wing lam on 03/12/2019.
//  Copyright © 2019 Samir Yeasin. All rights reserved.
//

import Foundation

class Doctor{
    var doctorId : Int = 0
    var firstName: String = ""
    var lastName : String = ""
    var location : String = ""
    
    init(doctorId : Int, firstName: String, lastName: String, location: String ){
        self.doctorId = doctorId
        self.firstName = firstName
        self.lastName = lastName
        self.location = location
    }
}
