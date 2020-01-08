//
//  MealSearchProductViewController.swift
//  NiziApp
//
//  Created by Wing lam on 05/01/2020.
//  Copyright © 2020 Samir Yeasin. All rights reserved.
//

import UIKit
import Kingfisher
import SwiftKeychainWrapper


class MealSearchProductViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let patientIntID : Int? = Int(KeychainWrapper.standard.string(forKey: "patientId")!)
    var foodlist : [Food] = []
    var mealfoodlist : [Food] = []
    @IBOutlet weak var MealProductsTable: UITableView!
    @IBOutlet weak var ProductText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func SearchProduct(_ sender: Any) {
        searchFood()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        foodlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchFoodCell = tableView.dequeueReusableCell(withIdentifier: "ProductMealCell", for: indexPath) as! SearchFoodTableViewCell
        let idx: Int = indexPath.row
        searchFoodCell.textLabel?.text = foodlist[idx].name
        let url = URL(string: foodlist[idx].picture)
        searchFoodCell.imageView?.kf.setImage(with: url)
        searchFoodCell.accessoryType = .disclosureIndicator
        return searchFoodCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let food = self.foodlist[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailFoodVC = storyboard.instantiateViewController(withIdentifier:"MealProductDetailListViewController") as! MealProductDetailViewController;()
        detailFoodVC.foodItem = food
        detailFoodVC.foodlist = mealfoodlist
        self.navigationController?.pushViewController(detailFoodVC, animated: true)
    }
    
    
    
    
    func searchFood() {
        NiZiAPIHelper.searchProducts(byName: ProductText.text!, authenticationCode: KeychainWrapper.standard.string(forKey: "authToken")!).responseData(completionHandler: { response in
            
            guard let jsonResponse = response.data
                else { print("temp1"); return }
            
            let jsonDecoder = JSONDecoder()
            guard let foodlistJSON = try? jsonDecoder.decode( [Food].self, from: jsonResponse )
                else { print("temp2"); return }
            
            self.foodlist = foodlistJSON
            self.MealProductsTable?.reloadData()
        })
    }
    @IBAction func BackToCreate(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailFoodVC = storyboard.instantiateViewController(withIdentifier:"CreateMealViewController") as! CreateMealViewController;()
        detailFoodVC.Mealfoodlist = mealfoodlist
        self.navigationController?.pushViewController(detailFoodVC, animated: true)
    }
}
