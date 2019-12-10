//
//  DiaryTableViewCell.swift
//  NiziApp
//
//  Created by Wing lam on 10/12/2019.
//  Copyright © 2019 Samir Yeasin. All rights reserved.
//

import UIKit

class DiaryTableViewCell: UITableViewCell {

    @IBOutlet var productTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
