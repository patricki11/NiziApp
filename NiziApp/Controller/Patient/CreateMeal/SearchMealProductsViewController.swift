//
//  SearchMealProductsViewController.swift
//  NiziApp
//
//  Created by Samir Yeasin on 09/12/2020.
//  Copyright © 2020 Samir Yeasin. All rights reserved.
//

import UIKit

class SearchMealProductsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var foodlist : [NewFood] = []
    var Mealfoodlist : [NewFood] = []
    let patientIntID : Int = 1

    @IBOutlet weak var searchFoodInput: UITextField!
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var productTable: UITableView!
    
    @IBAction func searchFoodAction(_ sender: Any) {
        searchFood()
    }
    
    @IBAction func goBackToCreateMeal(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchFoodCell = tableView.dequeueReusableCell(withIdentifier: "searchFoodCell", for: indexPath) as! SearchFoodTableViewCell
        let idx: Int = indexPath.row
        let foodResult : NewFood = foodlist[idx]
        searchFoodCell.foodTitle?.text = foodlist[idx].name
        let url = URL(string: (foodResult.foodMealComponent?.imageUrl)!)
        searchFoodCell.foodImage?.kf.setImage(with: url)
        searchFoodCell.accessoryType = .disclosureIndicator
        let portionSizeString : String = String(format:"%.f",foodResult.foodMealComponent?.portionSize as! CVarArg)
        searchFoodCell.portionSize?.text = ("portie: " + portionSizeString + " " + (foodResult.weightObject?.unit)!)
        searchFoodCell.foodItem = foodResult
        return searchFoodCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let food = self.foodlist[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailFoodVC = storyboard.instantiateViewController(withIdentifier:"ProductDetailListViewController") as! FoodDetailViewController;()
        detailFoodVC.foodItem = food.foodMealComponent
        detailFoodVC.weightUnit = food.weightObject
       // detailFoodVC.patient = self.patient
        detailFoodVC.food = food
        self.navigationController?.pushViewController(detailFoodVC, animated: true)
    }
    
    //MARK: API CALLS

    func searchFood() {
        NiZiAPIHelper.getFood(withToken: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiaWF0IjoxNjA1MTA0Njk3LCJleHAiOjE2MDc2OTY2OTd9.VQqpsXC4IrdPjcNE9cuMpwumiLncAKorGB8eIDAWS2Y", withFood: searchFoodInput.text!).responseData(completionHandler: { response in
            
            guard let jsonResponse = response.data
                else { print("temp1"); return }
            
            let jsonDecoder = JSONDecoder()
            guard let foodlistJSON = try? jsonDecoder.decode( [NewFood].self, from: jsonResponse )
                else { print("temp2"); return }
            
            self.foodlist = foodlistJSON
            self.productTable?.reloadData()
            self.totalLbl.text = "Aantal(\(self.foodlist.count))"
        })
    }
    
    
}
