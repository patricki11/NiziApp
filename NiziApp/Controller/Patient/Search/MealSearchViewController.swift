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
    @IBOutlet weak var searchMeal: UITextField!
    @IBOutlet weak var totalLabel: UILabel!
    
    var meallist : [NewMeal] = []
    let patientIntID : Int = Int(KeychainWrapper.standard.string(forKey: "patientId")!)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchMeal.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        GetMeals()
        //removeKeyboardAfterClickingOutsideField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.GetMeals()
    }
    
    @objc func textFieldDidChange(textField: UITextField){
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
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            showConfirmDeleteFavorite(indexPath: indexPath)
        }
    }
    
    func showConfirmDeleteFavorite(indexPath: IndexPath) {
        let alertController = UIAlertController(
            title:NSLocalizedString("MealDeletedTitle", comment: ""),
            message: NSLocalizedString("MealDeletedMessage", comment: ""),
            preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("CancelTitle", comment: "Annuleren"), style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "Ok"), style: .default, handler: { _ in self.deleteFavorite(favorite: self.meallist[indexPath.row])
            self.meallist.remove(at: indexPath.row)
            self.MealTable?.deleteRows(at: [indexPath], with: .fade)
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func deleteFavorite(favorite: NewMeal) {
        deleteFavoriteObject(forFavorite: favorite)
    }
    
    func deleteFavoriteObject(forFavorite patient: NewMeal) {
        NiZiAPIHelper.deleteMeal(withToken: KeychainWrapper.standard.string(forKey: "authToken")!, withMealId: patient.id).responseData(completionHandler: { _ in
            
            self.showFavoriteDeletedMessage()
        })
    }
    
    func showFavoriteDeletedMessage() {
        let alertController = UIAlertController(
            title:NSLocalizedString("MealDeletedTitle", comment: ""),
            message: NSLocalizedString("MealDeletedConfirmed", comment: ""),
            preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "Ok"), style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func GetMeals() {
        NiZiAPIHelper.getMeals(withToken: KeychainWrapper.standard.string(forKey: "authToken")!, withPatient: patientIntID, withText: searchMeal.text!).responseData(completionHandler: { response in
            
            guard let jsonResponse = response.data
            else { print("temp1"); return }
            
            let jsonDecoder = JSONDecoder()
            guard let MeallistJSON = try? jsonDecoder.decode( [NewMeal].self, from: jsonResponse )
            else { print("temp2"); return }
            
            self.meallist = MeallistJSON
            self.MealTable?.reloadData()
            self.totalLabel.text = "\(NSLocalizedString("Result", comment: ""))(\(self.meallist.count))"
        })
        
    }
    
    @IBAction func goToCreateMeal(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailFoodVC = storyboard.instantiateViewController(withIdentifier:"NewCreateMealViewController") as! NewCreateMealViewController;()
        self.navigationController?.pushViewController(detailFoodVC, animated: true)
    }
}


