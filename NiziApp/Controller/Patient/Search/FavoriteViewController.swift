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
    let patientIntID : Int = Int(KeychainWrapper.standard.string(forKey: "patientId")!)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GetFavortiesFood()
        searchInput.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(textField: UITextField){
        GetFavortiesFoodSearch()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        GetFavortiesFood()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func navigateProduct(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailFoodVC = storyboard.instantiateViewController(withIdentifier:"ProductListViewController") as! SearchFoodViewController;()
        self.navigationController?.pushViewController(detailFoodVC, animated: false)
    }
    
    @IBAction func navigateMeal(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailFoodVC = storyboard.instantiateViewController(withIdentifier:"MealSearchViewController") as! MealSearchViewController;()
        self.navigationController?.pushViewController(detailFoodVC, animated: false)
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
        let detailFoodVC = storyboard.instantiateViewController(withIdentifier:"DetailFoodViewController") as! DetailFoodViewController;()
        detailFoodVC.foodItem = food.food?.foodMealComponent
        detailFoodVC.favorite = self.createFavoriteShort(id: food.id!, food: (food.food?.id)!)
        detailFoodVC.foodObject = food.food
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
            title:NSLocalizedString("Verwijder Favoriet", comment: ""),
            message: NSLocalizedString("Weet u zeker dat u favoriet wil verwijderen?", comment: ""),
            preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Annuleer", comment: "Annuleren"), style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "Ok"), style: .default, handler: { _ in self.deleteFavorite(favorite: self.foodlist[indexPath.row])
            self.foodlist.remove(at: indexPath.row)
            self.FavoriteTable?.deleteRows(at: [indexPath], with: .fade)
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func deleteFavorite(favorite: NewFavorite) {
        deleteFavoriteObject(forFavorite: favorite)
    }
    
    func deleteFavoriteObject(forFavorite patient: NewFavorite) {
        NiZiAPIHelper.deleteFavorite(withToken: KeychainWrapper.standard.string(forKey: "authToken")! , withConsumptionId: patient.id! ).responseData(completionHandler: { _ in
            
            self.showFavoriteDeletedMessage()
        })
    }
    
    func showFavoriteDeletedMessage() {
        let alertController = UIAlertController(
            title:NSLocalizedString("Favoriet is verwijdert", comment: ""),
            message: NSLocalizedString("Favoriet is verwijdert", comment: ""),
            preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "Ok"), style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    func GetFavortiesFood() {
        NiZiAPIHelper.GetMyFoods(withToken: KeychainWrapper.standard.string(forKey: "authToken")!, withPatient: self.patientIntID).responseData(completionHandler: { response in
            
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
    
    func GetFavortiesFoodSearch() {
        NiZiAPIHelper.GetMyFoodsSearch(withToken: KeychainWrapper.standard.string(forKey: "authToken")!, withPatient: self.patientIntID, withFood: searchInput.text!).responseData(completionHandler: { response in
            
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
    
    func createFavoriteShort(id: Int, food : Int) -> NewFavoriteShort {
        let favoriteShort : NewFavoriteShort = NewFavoriteShort(id: id, food: food)
        return favoriteShort
    }
    
}
