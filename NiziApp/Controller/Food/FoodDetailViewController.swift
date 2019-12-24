//
//  FoodDetailViewController.swift
//  NiziApp
//
//  Created by Wing lam on 23/12/2019.
//  Copyright © 2019 Samir Yeasin. All rights reserved.
//

import UIKit

class FoodDetailViewController: UIViewController {
    @IBOutlet weak var DetailTitle: UILabel!
    @IBOutlet weak var Portion: UILabel!
    @IBOutlet weak var AmountPortion: UILabel!
    @IBOutlet weak var ConsumtionValues: UILabel!
    @IBOutlet weak var Kcal: UILabel!
    @IBOutlet weak var Protein: UILabel!
    @IBOutlet weak var Fiber: UILabel!
    @IBOutlet weak var Calcium: UILabel!
    @IBOutlet weak var Sodium: UILabel!
    @IBOutlet weak var Picture: UIImageView!
    
    var foodItem: Food?

    override func viewDidLoad() {
        super.viewDidLoad()
        SetupData()
    }
    
    func SetupData()
    {
        DetailTitle.text = foodItem?.name
        
        let url = URL(string: foodItem!.picture)
        Picture.kf.setImage(with: url)
        
        let calorieString : String = String(format:"%.1f",foodItem!.kCal)
        Kcal.text = calorieString
        
        let proteinString : String = String(format:"%.1f",foodItem!.protein)
        Protein.text = proteinString
        
        let fiberString : String = String(format:"%.1f",foodItem!.fiber)
        Fiber.text = fiberString
        
        let calciumString : String = String(format:"%.1f",foodItem!.calcium)
        Calcium.text = calciumString
        
        let sodiumString : String = String(format:"%.1f",foodItem!.sodium)
        Sodium.text = sodiumString
        
    }
}
