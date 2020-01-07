//
//  CreateMealViewController.swift
//  NiziApp
//
//  Created by Wing lam on 04/01/2020.
//  Copyright © 2020 Samir Yeasin. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Kingfisher

class CreateMealViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var Mealfoodlist : [Food] = []
    var kcal : Double = 0.0
    var fiberMeal : Double = 0.0
    var vochtMeal : Double = 0.0
    var pottassiumMeal : Double = 0.0
    var sodiumMeal : Double = 0.0
    var proteinMeal : Double = 0.0
    
    
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var NameText: UITextField!
    @IBOutlet weak var MealProducts: UITableView!
    @IBOutlet weak var KcalLabel: UILabel!
    @IBOutlet weak var FiberLabel: UILabel!
    @IBOutlet weak var ProteinLabel: UILabel!
    @IBOutlet weak var VochtLabel: UILabel!
    @IBOutlet weak var SodiumLabel: UILabel!
    @IBOutlet weak var PotassiumLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calculateDietary()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool){
        MealProducts?.reloadData()
        
    }
    
    
    @IBAction func SearchProducts(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailFoodVC = storyboard.instantiateViewController(withIdentifier:"MealSearchProductViewController") as! MealSearchProductViewController;()
        detailFoodVC.mealfoodlist = Mealfoodlist
        self.navigationController?.pushViewController(detailFoodVC, animated: true)
    }
    
    @IBAction func CreateMeal(_ sender: Any) {
        addMeal()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Mealfoodlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchFoodCell = tableView.dequeueReusableCell(withIdentifier: "FoodMeal", for: indexPath) as! SearchFoodTableViewCell
        let idx: Int = indexPath.row
        searchFoodCell.textLabel?.text = Mealfoodlist[idx].name
        let url = URL(string: Mealfoodlist[idx].picture)
        searchFoodCell.imageView?.kf.setImage(with: url)
        searchFoodCell.accessoryType = .disclosureIndicator
        return searchFoodCell
    }
    
    func addMeal() {
        
        
        
        let meal = self.createNewMealObject(mealId: 4, name: NameText.text!, patientId: 57, kcal: kcal, fiber: fiberMeal, calcium: pottassiumMeal, sodium: sodiumMeal, portionSize: 1.0, weightUnit: "gram", picture: "https://image.flaticon.com/icons/png/512/45/45332.png", protein: proteinMeal)
        
        NiZiAPIHelper.addMeal(withDetails: meal, forPatient: 57, authenticationCode: KeychainWrapper.standard.string(forKey: "authToken")!).responseData(completionHandler: { response in
            // TODO: Melden aan patient dat de maaltijd is toegevoegd.
        })
    }
    
    func createNewMealObject(mealId: Int, name: String, patientId: Int, kcal: Double, fiber: Double, calcium: Double, sodium: Double, portionSize: Double, weightUnit: String, picture: String, protein: Double) -> Meal {
        
        let meal : Meal = Meal(
            mealId: mealId, name: name, patientId: patientId, kCal: kcal, protein: protein, fiber: fiber, calcium: calcium, sodium: sodium, portionSize: portionSize, weightUnit: weightUnit, picture: picture)
        return meal
    }
    
    func calculateDietary(){
        
        if(Mealfoodlist.count > 0){
            for food in Mealfoodlist {
                kcal += food.kCal
                fiberMeal += food.fiber
                vochtMeal += 0.0
                pottassiumMeal += food.calcium
                proteinMeal +=  food.protein
                sodiumMeal += food.sodium
                
            }
            let kcalText:String = String(format:"%.1f", kcal)
            KcalLabel.text = kcalText
            
            let fiberText:String = String(format:"%.1f", fiberMeal)
            FiberLabel.text = fiberText
            
            let vochtText:String = String(format:"%.1f", vochtMeal)
            VochtLabel.text = vochtText
            
            let pottassiumText:String = String(format:"%.1f", pottassiumMeal)
            PotassiumLabel.text = pottassiumText
            
            let proteinText:String = String(format:"%.1f", proteinMeal)
            ProteinLabel.text = proteinText
            
            let sodiumText:String = String(format:"%.1f", sodiumMeal)
            SodiumLabel.text = sodiumText
        }
        else{
            KcalLabel.text = "0.0"
            FiberLabel.text = "0.0"
            VochtLabel.text = "0.0"
            PotassiumLabel.text = "0.0"
            ProteinLabel.text = "0.0"
            SodiumLabel.text = "0.0"
        }
    }
    
}
