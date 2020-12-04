//
//  NewConversation.swift
//  NiziApp
//
//  Created by Samir Yeasin on 23/11/2020.
//  Copyright © 2020 Samir Yeasin. All rights reserved.
//

import Foundation

class NewConversation : Codable {
    var id        : Int?    = 0
    var title     : String? = ""
    var comment   : String? = ""
    var date      : String? = ""
    var isRead    : Bool?   = false
    var doctor    : NewDoctor? = nil
    var doctorId  : Int? = nil
    var patient   : NewPatient? = nil
    var patientId : Int? = nil
    
    init(id : Int?, title : String?, comment: String?, date: String?, isRead : Bool?, doctor : NewDoctor?, doctorId: Int?, patient : NewPatient?, patientId: Int?){
        self.id = id
        self.title = title
        self.comment = comment
        self.date = date
        self.isRead = isRead
        self.doctor = doctor
        self.doctorId = doctorId
        self.patient = patient
        self.patientId = patientId
    }
    
    enum CodingKeys : String, CodingKey {
        case id = "id"
        case title = "title"
        case comment = "comment"
        case date = "date"
        case isRead = "is_read"
        case doctor = "doctor"
        case patient = "patient"
    }
}
