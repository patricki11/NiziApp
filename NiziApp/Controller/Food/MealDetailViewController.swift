//
//  MealDetailViewController.swift
//  NiziApp
//
//  Created by Wing lam on 03/01/2020.
//  Copyright © 2020 Samir Yeasin. All rights reserved.
//

import UIKit

class MealDetailViewController: UIViewController {

    @IBOutlet weak var MealTitle: UILabel!
    @IBOutlet weak var MealPicture: UIImageView!
    @IBOutlet weak var MealPortion: UILabel!
    @IBOutlet weak var AmountPortion: UILabel!
    @IBOutlet weak var AmountField: UITextField!
    @IBOutlet weak var ConsumptionTitle: UILabel!
    @IBOutlet weak var CalorieText: UILabel!
    @IBOutlet weak var FiberText: UILabel!
    @IBOutlet weak var ProteinText: UILabel!
    @IBOutlet weak var WaterText: UILabel!
    @IBOutlet weak var SodiumText: UILabel!
    @IBOutlet weak var KaliumText: UILabel!
    
    var mealItem: Meal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetupData()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func AddMealtoDiary(_ sender: Any) {
    }
    
    func SetupData()
    {
        MealTitle.text = mealItem?.name
        
        let url = URL(string: mealItem!.picture)
        MealPicture.kf.setImage(with: url)
        
        let calorieString : String = String(format:"%.1f",mealItem!.kCal)
        CalorieText.text = calorieString
        
        let proteinString : String = String(format:"%.1f",mealItem!.protein)
        ProteinText.text = proteinString
        
        let fiberString : String = String(format:"%.1f",mealItem!.fiber)
        FiberText.text = fiberString
        
        let calciumString : String = String(format:"%.1f",mealItem!.calcium)
        KaliumText.text = calciumString
        
        let sodiumString : String = String(format:"%.1f",mealItem!.sodium)
        SodiumText.text = sodiumString
        
    }
    

}
