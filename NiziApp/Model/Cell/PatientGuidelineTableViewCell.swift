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
    @IBOutlet weak var averageAmountForWeekLabel: UILabel!
    @IBOutlet weak var recommendedAmountLabel: UILabel!
    
    @IBOutlet weak var guidelineIconImageView: UIImageView!
    
    @IBOutlet weak var guidelineChartView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        guidelineNameLabel.text = ""
        averageAmountForWeekLabel.text = ""
        recommendedAmountLabel.text = ""
        guidelineIconImageView.image = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
