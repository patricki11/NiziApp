//
//  MealTableViewCell.swift
//  NiziApp
//
//  Created by Samir Yeasin on 09/12/2020.
//  Copyright © 2020 Samir Yeasin. All rights reserved.
//

import UIKit

class MealTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subTitleLbl: UILabel!
    @IBOutlet weak var amountInput: UITextField!
    
    @IBAction func substractAction(_ sender: Any) {
    }
    @IBAction func IncrementAction(_ sender: Any) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
