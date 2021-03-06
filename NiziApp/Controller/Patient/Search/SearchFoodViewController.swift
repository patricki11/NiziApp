//
//  SearchFoodViewController.swift
//  NiziApp
//
//  Created by Wing lam on 11/12/2019.
//  Copyright © 2019 Samir Yeasin. All rights reserved.
//

import UIKit
import Kingfisher
import SwiftKeychainWrapper

class SearchFoodViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, PresentDialog {
    var foodlist                      : [NewFood] = []
    var buttonTag                     : Int = 0
    let patientIntID                  : Int = Int(KeychainWrapper.standard.string(forKey: "patientId")!)!
    var patient                       : NewPatient?
    @IBOutlet weak var FoodTable      : UITableView!
    @IBOutlet weak var SearchFoodInput: UITextField!
    @IBOutlet weak var favorietenBtn  : UIButton!
    @IBOutlet weak var ProductenBtn   : UIButton!
    @IBOutlet weak var results        : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SearchFoodInput.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        //removeKeyboardAfterClickingOutsideField()
    }
    
    @objc func textFieldDidChange(textField: UITextField){
        searchFood()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func productAction(_ sender: Any) {
    }
    
    @IBAction func GetFavorites(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailFoodVC = storyboard.instantiateViewController(withIdentifier:"FavoriteViewController") as! FavoriteViewController;()
        self.navigationController?.pushViewController(detailFoodVC, animated: false)
    }
    
    @IBAction func navigateMealSearch(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailFoodVC = storyboard.instantiateViewController(withIdentifier:"MealSearchViewController") as! MealSearchViewController;()
        self.navigationController?.pushViewController(detailFoodVC, animated: false)
    }
    
    func addDiary(succeeded: Bool) {
        if(succeeded){
            let alert = UIAlertController(title: NSLocalizedString("Sucess", comment: ""), message:NSLocalizedString("FoodHasBeenAdded", comment: ""), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
            }))
            present(alert, animated: true)
        }
    }
    
    //MARK: Table Functions
    
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
        searchFoodCell.dialog = self
        return searchFoodCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let food = self.foodlist[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailFoodVC = storyboard.instantiateViewController(withIdentifier:"DetailFoodViewController") as! DetailFoodViewController;()
        detailFoodVC.foodItem = food.foodMealComponent
        detailFoodVC.weightUnit = food.weightObject
        detailFoodVC.patient = self.patient
        detailFoodVC.favorite = food.favoriteFoods
        detailFoodVC.foodObject = food
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
    
    //MARK: API CALLS
    
    func searchFood() {
        NiZiAPIHelper.getFood(withToken: KeychainWrapper.standard.string(forKey: "authToken")!, withFood: SearchFoodInput.text!).responseData(completionHandler: { response in
            
            guard let jsonResponse = response.data
            else { print("temp1"); return }
            
            let jsonDecoder = JSONDecoder()
            guard let foodlistJSON = try? jsonDecoder.decode( [NewFood].self, from: jsonResponse )
            else { print("temp2"); return }
            
            self.foodlist = foodlistJSON
            self.FoodTable?.reloadData()
            self.results.text = "\(NSLocalizedString("Result", comment: ""))(\(self.foodlist.count))"
        })
    }
}


