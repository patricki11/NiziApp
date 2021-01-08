//
//  DietistTabBarController.swift
//  NiziApp
//
//  Created by Patrick Dammers on 08/01/2021.
//  Copyright © 2021 Samir Yeasin. All rights reserved.
//

import Foundation
import UIKit
import SwiftKeychainWrapper

class DietistTabBarController: UITabBarController {
   
    weak var patient: NewPatient?
    var doctorId: Int?
    
    var overviewView: PatientOverviewViewController!
    var conversationView: AddConversationViewController!
    var diaryView: ShowPatientDiaryViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setPatientDataInUnderlyingViews() {
        
        overviewView = self.viewControllers![0] as! PatientOverviewViewController
        overviewView.patient = patient
        overviewView.doctorId = doctorId
        
        diaryView = self.viewControllers![1] as! ShowPatientDiaryViewController
        diaryView.patient = patient

        conversationView = self.viewControllers![2] as! AddConversationViewController
        conversationView.patientId = patient?.id!
        conversationView.doctorId = doctorId
    }
}
