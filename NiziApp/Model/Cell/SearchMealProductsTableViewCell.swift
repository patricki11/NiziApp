//
//  SearchMealProductsTableViewCell.swift
//  NiziApp
//
//  Created by Samir Yeasin on 11/01/2021.
//  Copyright © 2021 Samir Yeasin. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class SearchMealProductsTableViewCell: UITableViewCell {

    var foodItem : NewFood!
    var index : Int = 0
    var weightUnit : Int = 0
    let patientIntID : Int = Int(KeychainWrapper.standard.string(forKey: "patientId")!)!
    //var dialog : PresentDialog?
    var cartSelectionDelegate: CartSelection?
    
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var foodTitle: UILabel!
    @IBOutlet weak var portionSize: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    @IBAction func QuickAdd(_ sender: Any) {
        cartSelectionDelegate?.addProductToCart(product: foodItem, atindex: index)
    }

}
