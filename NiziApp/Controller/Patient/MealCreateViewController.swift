//
//  MealCreateViewController.swift
//  NiziApp
//
//  Created by Samir Yeasin on 09/12/2020.
//  Copyright © 2020 Samir Yeasin. All rights reserved.
//

import UIKit

class MealCreateViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var foodListTable: UITableView!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var searchFoodBtn: UIButton!
    @IBOutlet weak var importBtn: UIButton!
    @IBOutlet weak var secondTitleLbl: UILabel!
    @IBOutlet weak var calorieResultLbl: UILabel!
    @IBOutlet weak var fiberResultLbl: UILabel!
    @IBOutlet weak var proteinResultLbl: UILabel!
    @IBOutlet weak var waterResultLbl: UILabel!
    @IBOutlet weak var sodiumResultLbl: UILabel!
    @IBOutlet weak var potassiumResultLbl: UILabel!
    
    var Mealfoodlist : [NewFood] = []

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Mealfoodlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let productsMealCell = tableView.dequeueReusableCell(withIdentifier: "FoodMealCell", for: indexPath) as! MealTableViewCell
        let idx: Int = indexPath.row
        productsMealCell.titleLbl.text = Mealfoodlist[idx].foodMealComponent?.name
        let portionSizeString : String = String(format:"%.f",Mealfoodlist[idx].foodMealComponent?.portionSize as! CVarArg)
        productsMealCell.subTitleLbl.text = ( portionSizeString + " " + (Mealfoodlist[idx].weightObject?.unit)!)
        return productsMealCell
    }

}
