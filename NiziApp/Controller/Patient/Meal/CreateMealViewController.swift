//
//  CreateMealViewController.swift
//  NiziApp
//
//  Created by Wing lam on 04/01/2020.
//  Copyright © 2020 Samir Yeasin. All rights reserved.
//

import UIKit

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
    
}
