//
//  PatientGuidelineTableViewCell.swift
//  NiziApp
//
//  Created by Samir Yeasin on 03/01/2020.
//  Copyright © 2020 Samir Yeasin. All rights reserved.
//

import Foundation
import UIKit

class PatientGuidelineTableViewCell : UITableViewCell {

    @IBOutlet weak var guidelineNameLabel: UILabel!
    @IBOutlet weak var firstGuidelineValueLabel: UILabel!
    @IBOutlet weak var secondGuidelineValueLabel: UILabel!
    
    @IBOutlet weak var guidelineIconImageView: UIImageView!
    
    @IBOutlet weak var guidelineChartView: UIView!
    
    @IBOutlet weak var feedbackLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        guidelineNameLabel.text = ""
        firstGuidelineValueLabel.text = ""
        secondGuidelineValueLabel.text = ""
        guidelineIconImageView.image = nil
        feedbackLabel.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
