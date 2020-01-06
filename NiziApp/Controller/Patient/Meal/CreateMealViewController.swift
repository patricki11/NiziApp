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
    
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var NameText: UITextField!
    @IBOutlet weak var MealProducts: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
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
        let meal = self.createNewMealObject(mealId: 4, name: NameText.text!, patientId: 57, kcal: 10.0, fiber: 10.0, calcium: 10.0, sodium: 10.0, portionSize: 1.0, weightUnit: "gram", picture: "https://image.flaticon.com/icons/png/512/45/45332.png", protein: 10.0)
        
        NiZiAPIHelper.addMeal(withDetails: meal, forPatient: 57, authenticationCode: KeychainWrapper.standard.string(forKey: "authToken")!).responseData(completionHandler: { response in
            // TODO: Melden aan patient dat de maaltijd is toegevoegd.
        })
    }
    
    func createNewMealObject(mealId: Int, name: String, patientId: Int, kcal: Double, fiber: Double, calcium: Double, sodium: Double, portionSize: Double, weightUnit: String, picture: String, protein: Double) -> Meal {
        
        let meal : Meal = Meal(
            mealId: mealId, name: name, patientId: patientId, kCal: kcal, protein: protein, fiber: fiber, calcium: calcium, sodium: sodium, portionSize: portionSize, weightUnit: weightUnit, picture: picture)
        return meal
    }
    
}
