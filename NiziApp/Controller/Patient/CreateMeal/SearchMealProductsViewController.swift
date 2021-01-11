//
//  SearchMealProductsViewController.swift
//  NiziApp
//
//  Created by Samir Yeasin on 09/12/2020.
//  Copyright © 2020 Samir Yeasin. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class SearchMealProductsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CartSelection {
    
    func addProductToCart(product: NewFood, atindex: Int) {
        var productExist = false
        
        for productSearch in Mealfoodlist {
            if(productSearch.id == product.id){
                productExist = true
            }
        }
        product.amount = Float(1.0)
        
        if(productExist == false){
            Mealfoodlist.append(product)
        }
        let alert = UIAlertController(title: "Success", message: "Voedel is toegevoegd aan maaltijd", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
        }))
        present(alert, animated: true)
    }
    
    var foodlist : [NewFood] = []
    var Mealfoodlist : [NewFood] = []
    let patientIntID : Int = Int(KeychainWrapper.standard.string(forKey: "patientId")!)!
    var editMealObject : NewMeal?
    var editMeal : Bool = false
    var editMealsHasbeenRetrieved : Bool = false
    
    @IBOutlet weak var searchFoodInput: UITextField!
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var productTable: UITableView!
    
    @IBAction func searchFoodAction(_ sender: Any) {
        searchFood()
    }
    
    @IBAction func goBackToCreateMeal(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailFoodVC = storyboard.instantiateViewController(withIdentifier:"NewCreateMealViewController") as! NewCreateMealViewController;()
        detailFoodVC.Mealfoodlist = Mealfoodlist
        
        if(editMeal){
            detailFoodVC.editMealObject = self.editMealObject
            detailFoodVC.editMeal = true
            detailFoodVC.editMealsHasbeenRetrieved = true
        }
        self.navigationController?.pushViewController(detailFoodVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchFoodInput.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        //removeKeyboardAfterClickingOutsideField()
    }
    
    @objc func textFieldDidChange(textField: UITextField){
        searchFood()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchFoodCell = tableView.dequeueReusableCell(withIdentifier: "searchMealFoodCell", for: indexPath) as! SearchMealProductsTableViewCell
        let idx: Int = indexPath.row
        let foodResult : NewFood = foodlist[idx]
        searchFoodCell.foodTitle?.text = foodlist[idx].name
        let url = URL(string: (foodResult.foodMealComponent?.imageUrl)!)
        searchFoodCell.foodImage?.kf.setImage(with: url)
        searchFoodCell.accessoryType = .disclosureIndicator
        let portionSizeString : String = String(format:"%.f",foodResult.foodMealComponent?.portionSize as! CVarArg)
        searchFoodCell.portionSize?.text = ("portie: " + portionSizeString + " " + (foodResult.weightObject?.unit)!)
        searchFoodCell.foodItem = foodResult
        searchFoodCell.index = idx
        searchFoodCell.cartSelectionDelegate = self
        return searchFoodCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let food = self.foodlist[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailFoodVC = storyboard.instantiateViewController(withIdentifier:"DetailFoodViewController") as! DetailFoodViewController;()
        
        detailFoodVC.foodItem = food.foodMealComponent
        detailFoodVC.weightUnit = food.weightObject
        detailFoodVC.food = food
        detailFoodVC.Mealfoodlist = Mealfoodlist
        detailFoodVC.isMealProductDetail = true
        
        if(editMeal){
            detailFoodVC.editMeal = true
            detailFoodVC.editMealObject = self.editMealObject
            detailFoodVC.editMealsHasbeenRetrieved = true
        }
        self.navigationController?.pushViewController(detailFoodVC, animated: true)
    }
    
    //MARK: API CALLS
    
    func searchFood() {
        NiZiAPIHelper.getFood(withToken: KeychainWrapper.standard.string(forKey: "authToken")!, withFood: searchFoodInput.text!).responseData(completionHandler: { response in
            
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

extension SearchMealProductsViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        (viewController as? MealCreateViewController)?.Mealfoodlist = Mealfoodlist // Here you pass the to your original view controller
    }
}
