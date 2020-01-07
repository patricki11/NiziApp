//
//  MealProductDetailViewController.swift
//  NiziApp
//
//  Created by Wing lam on 05/01/2020.
//  Copyright © 2020 Samir Yeasin. All rights reserved.
//

import UIKit

class MealProductDetailViewController: UIViewController {
    
    var foodItem: Food?
    var foodlist : [Food] = []
    
    @IBOutlet weak var FoodPicture: UIImageView!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var PortionLabel: UILabel!
    @IBOutlet weak var AmountLabel: UILabel!
    @IBOutlet weak var AmountText: UITextField!
    @IBOutlet weak var Consumptiontitle: UILabel!
    @IBOutlet weak var KcalLabel: UILabel!
    @IBOutlet weak var FiberLabel: UILabel!
    @IBOutlet weak var ProteinLabel: UILabel!
    @IBOutlet weak var SodiumLabel: UILabel!
    @IBOutlet weak var CalciumLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetupData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           // Hide the Navigation Bar
           self.navigationController?.setNavigationBarHidden(true, animated: animated)
       }
    
    
    func SetupData()
    {
        TitleLabel.text = foodItem?.name
        
        let url = URL(string: foodItem!.picture)
        FoodPicture.kf.setImage(with: url)
        
        let calorieString : String = String(format:"%.1f",foodItem!.kCal)
        KcalLabel.text = calorieString
        
        let proteinString : String = String(format:"%.1f",foodItem!.protein)
        ProteinLabel.text = proteinString
        
        let fiberString : String = String(format:"%.1f",foodItem!.fiber)
        FiberLabel.text = fiberString
        
        let calciumString : String = String(format:"%.1f",foodItem!.calcium)
        SodiumLabel.text = calciumString
        
        let sodiumString : String = String(format:"%.1f",foodItem!.sodium)
        SodiumLabel.text = sodiumString
        
    }
    
    @IBAction func AddtoMeal(_ sender: Any) {
        foodlist.append(foodItem!)
    }
    
    @IBAction func FinishMeal(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailFoodVC = storyboard.instantiateViewController(withIdentifier:"CreateMealViewController") as! CreateMealViewController;()
        detailFoodVC.Mealfoodlist = foodlist
        self.navigationController?.pushViewController(detailFoodVC, animated: true)
    }
    
    @IBAction func BacktoSearch(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailFoodVC = storyboard.instantiateViewController(withIdentifier:"MealSearchProductViewController") as! MealSearchProductViewController;()
        detailFoodVC.mealfoodlist = foodlist
        self.navigationController?.pushViewController(detailFoodVC, animated: true)
    }
}
