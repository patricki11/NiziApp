//
//  MealTableViewCell.swift
//  NiziApp
//
//  Created by Samir Yeasin on 09/12/2020.
//  Copyright © 2020 Samir Yeasin. All rights reserved.
//

import UIKit

class MealTableViewCell: UITableViewCell {
    
    var number : Int = 0
    var cartSelectionDelegate: CartSelection?
    var food : NewFood!
    var index : Int = 0

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subTitleLbl: UILabel!
    @IBOutlet weak var amountInput: UITextField!
    
    @IBAction func substractAction(_ sender: Any) {
        var numberon = Int(amountInput.text!)
        numberon!-=1
        amountInput.text = numberon?.description
    }
    @IBAction func IncrementAction(_ sender: Any) {
        var numberon = Int(amountInput.text!)
        numberon!+=1
        amountInput.text = numberon?.description
        food.foodMealComponent?.portionSize = Float(2)
        cartSelectionDelegate?.addProductToCart(product: food, atindex: index)
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
