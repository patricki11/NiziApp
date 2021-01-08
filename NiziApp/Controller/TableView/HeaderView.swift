//
//  HeaderView.swift
//  NiziApp
//
//  Created by Samir Yeasin on 23/03/2020.
//  Copyright © 2020 Samir Yeasin. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class HeaderView: UITableViewCell {

    @IBOutlet weak var AddButton: UIButton!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var headerImageView: UIImageView!
    
    var navigation: NavigateToFood?
    var mealTime : String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

     
    }
    
    @IBAction func GotoDiary(_ sender: Any) {
    
        KeychainWrapper.standard.set(mealTime, forKey: "mealTime")
        navigation?.goToSearch(mealTime: mealTime)
       
    }
}


