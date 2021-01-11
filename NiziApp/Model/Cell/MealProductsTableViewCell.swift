//
//  MealProductsTableViewCell.swift
//  NiziApp
//
//  Created by Samir Yeasin on 11/01/2021.
//  Copyright © 2021 Samir Yeasin. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class MealProductsTableViewCell: UITableViewCell {

    var number : Float = 0
    var cartSelectionDelegate: CartSelection?
    var food : NewFood!
    var index : Int = 0
    let onlyAllowNumbersDelegate = OnlyAllowNumbersDelegate()

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subTitleLbl: UILabel!
    @IBOutlet weak var amountInput: UITextField!
    
    @objc func textFieldDidChange(textField: UITextField){
     print("text changed")
        let str = amountInput.text ?? "1.0"
        if var mFloat = Float(str) {
            if mFloat > 0.1 {
                amountInput.text = mFloat.description
                food.amount = Float(mFloat)
                cartSelectionDelegate?.addProductToCart(product: food, atindex: index)
            }
        }else {
            amountInput.text = "1.0"
            food.amount = 1.0
            cartSelectionDelegate?.addProductToCart(product: food, atindex: index)
            
        }
    }
    
    @IBAction func substractAction(_ sender: Any) {
        /*
        var numberon = Float(amountInput.text!)
        numberon!-=1
        amountInput.text = numberon?.description
        food.amount = Float(numberon!)
        cartSelectionDelegate?.addProductToCart(product: food, atindex: index)
 */
        
        let str = amountInput.text ?? "1.0"
        if var mFloat = Float(str) {
            mFloat -= 0.5
            if mFloat > 0.1 {
                amountInput.text = mFloat.description
                food.amount = Float(mFloat)
                cartSelectionDelegate?.addProductToCart(product: food, atindex: index)
            }
        }else {
            amountInput.text = "1.0"
            food.amount = 1.0
            cartSelectionDelegate?.addProductToCart(product: food, atindex: index)
            
        }
    }
    @IBAction func IncrementAction(_ sender: Any) {
        /*
        var numberon = Float(amountInput.text!)
        numberon!+=1
        amountInput.text = numberon?.description
        food.amount = Float(numberon!)
        cartSelectionDelegate?.addProductToCart(product: food, atindex: index)
 */
        
        let str = amountInput.text ?? "1.0"
        if var mFloat = Float(str) {
            mFloat += 0.5
            if mFloat > 0.1 {
                amountInput.text = mFloat.description
                food.amount = Float(mFloat)
                cartSelectionDelegate?.addProductToCart(product: food, atindex: index)
            }
        }else {
            amountInput.text = "1.0"
            food.amount = 1.0
            cartSelectionDelegate?.addProductToCart(product: food, atindex: index)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        amountInput.delegate = onlyAllowNumbersDelegate
        amountInput.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
