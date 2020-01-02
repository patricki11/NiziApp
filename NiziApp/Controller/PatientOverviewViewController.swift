//
//  PatientOverviewViewController.swift
//  NiziApp
//
//  Created by Samir Yeasin on 02/01/2020.
//  Copyright © 2020 Samir Yeasin. All rights reserved.
//

import Foundation
import UIKit


class PatientOverviewViewController : UIViewController
{
    weak var patient : Patient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "\(patient.firstName!) \(patient.lastName!)"
    }
}
