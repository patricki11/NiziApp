//
//  FavoriteViewController.swift
//  NiziApp
//
//  Created by Wing lam on 24/12/2019.
//  Copyright © 2020 Samir Yeasin. All rights reserved.
//

import UIKit
import Kingfisher
import SwiftKeychainWrapper

class FavoriteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var searchInput: UITextField!
    @IBOutlet weak var FavoriteTable: UITableView!
    @IBOutlet weak var totalResultLbl: UILabel!
    
    var foodlist : [NewFavorite] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GetFavortiesFood()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the Navigation Bar
        //self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchFoodCell = tableView.dequeueReusableCell(withIdentifier: "favoriteFoodCell", for: indexPath) as! SearchFoodTableViewCell
        let idx: Int = indexPath.row
        let foodResult : NewFood = foodlist[idx].food!
        searchFoodCell.foodTitle.text = foodResult.name
        let url = URL(string: foodResult.foodMealComponent!.imageUrl)
        searchFoodCell.foodImage.kf.setImage(with: url)
        searchFoodCell.accessoryType = .disclosureIndicator
        let portionSize : String = String(format:"%.f",foodResult.foodMealComponent?.portionSize as! CVarArg)
        searchFoodCell.portionSize.text = ("")
        print(foodResult.weightId)
        return searchFoodCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let food = self.foodlist[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailFoodVC = storyboard.instantiateViewController(withIdentifier:"ProductDetailListViewController") as! FoodDetailViewController;()
        detailFoodVC.foodItem = food.food?.foodMealComponent
        self.navigationController?.pushViewController(detailFoodVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            foodlist.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
    
    func GetFavortiesFood() {
        NiZiAPIHelper.GetMyFoods(withToken: KeychainWrapper.standard.string(forKey: "authToken")!, withPatient: 1).responseData(completionHandler: { response in
            
            guard let jsonResponse = response.data
                else { print("temp1"); return }
            
            let jsonDecoder = JSONDecoder()
            guard let foodlistJSON = try? jsonDecoder.decode( [NewFavorite].self, from: jsonResponse )
                else { print("temp2"); return }
            
            self.foodlist = foodlistJSON
            self.FavoriteTable?.reloadData()
            self.totalResultLbl.text = "Aantal(\(self.foodlist.count))"
        })
        
    }
    
    @IBAction func searchFoodByText(_ sender: Any) {
        print("Searching Favorite Food")
    }
    
}
