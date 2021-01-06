//
//  MealSearchViewController.swift
//  NiziApp
//
//  Created by Wing lam on 02/01/2020.
//  Copyright © 2020 Samir Yeasin. All rights reserved.
//

import UIKit
import Kingfisher
import SwiftKeychainWrapper

class MealSearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var MealTable: UITableView!
    var meallist : [NewMeal] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //removeKeyboardAfterClickingOutsideField()
        GetMeals()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.GetMeals()
    }
    
    
    @IBAction func navigateSearchProducts(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailFoodVC = storyboard.instantiateViewController(withIdentifier:"ProductListViewController") as! SearchFoodViewController;()
        self.navigationController?.pushViewController(detailFoodVC, animated: false)
    }
    
    @IBAction func navigateFavoriteProducts(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailFoodVC = storyboard.instantiateViewController(withIdentifier:"FavoriteViewController") as! FavoriteViewController;()
        self.navigationController?.pushViewController(detailFoodVC, animated: false)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meallist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchFoodCell = tableView.dequeueReusableCell(withIdentifier: "MealCell", for: indexPath) as! SearchFoodTableViewCell
        let idx: Int = indexPath.row
        searchFoodCell.textLabel?.text = meallist[idx].foodMealComponent.name
        let url = URL(string: meallist[idx].foodMealComponent.imageUrl)
        searchFoodCell.imageView!.kf.setImage(with: url)
        searchFoodCell.accessoryType = .disclosureIndicator
     
        return searchFoodCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let meal = self.meallist[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailFoodVC = storyboard.instantiateViewController(withIdentifier:"DetailFoodViewController") as! DetailFoodViewController;()
        detailFoodVC.foodItem = meal.foodMealComponent
        detailFoodVC.weightUnit = meal.weightUnit
        detailFoodVC.isMealDetail = true
        detailFoodVC.meal = meal
        self.navigationController?.pushViewController(detailFoodVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //DeleteMeal(Id: meallist[indexPath.row].mealId)
            meallist.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
    
    func GetMeals() {
        
        NiZiAPIHelper.getMeals(withToken: KeychainWrapper.standard.string(forKey: "authToken")!, withPatient: 1).responseData(completionHandler: { response in
            
            guard let jsonResponse = response.data
                else { print("temp1"); return }
            
            let jsonDecoder = JSONDecoder()
            guard let MeallistJSON = try? jsonDecoder.decode( [NewMeal].self, from: jsonResponse )
                else { print("temp2"); return }
            
            self.meallist = MeallistJSON
            self.MealTable?.reloadData()
        })
         
    }
    
    func DeleteMeal(Id id: Int){
        /*
        NiZiAPIHelper.deleteMeal(withId: id, forPatient: patientIntID!, authenticationCode: KeychainWrapper.standard.string(forKey: "authToken")!).responseData(completionHandler: { response in
            guard response.data != nil
                else { print("temp1"); return }
        })
        */
    }
    
    
    @IBAction func goToCreateMeal(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailFoodVC = storyboard.instantiateViewController(withIdentifier:"MealCreateViewController") as! MealCreateViewController;()
        self.navigationController?.pushViewController(detailFoodVC, animated: true)
    }
}
