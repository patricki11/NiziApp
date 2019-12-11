//
//  PatientListTableViewCell.swift
//  NiziApp
//
//  Created by Samir Yeasin on 11/12/2019.
//  Copyright © 2019 Samir Yeasin. All rights reserved.
//

import Foundation
import UIKit

class PatientListTableViewCell : UITableViewCell {
    
    @IBOutlet var patientNumber: UILabel!
    @IBOutlet var patientName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
           // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

           // Configure the view for the selected state
    }
}
