//
//  MealCreateViewController.swift
//  NiziApp
//
//  Created by Samir Yeasin on 09/12/2020.
//  Copyright © 2020 Samir Yeasin. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class MealCreateViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var label: UILabel!
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
    
    var Mealfoodlist    : [NewFood] = []
    var newMealFoodList : [NewMealFood] = []
    var kcal            : Float = 0.0
    var fiberMeal       : Float = 0.0
    var vochtMeal       : Float = 0.0
    var pottassiumMeal  : Float = 0.0
    var sodiumMeal      : Float = 0.0
    var proteinMeal     : Float = 0.0
    var createdMeal     : NewMeal?
    var mealListId      : [HelperId]?
    var productId       : [HelperId]?
    var editMeal        : Bool = false

    typealias FinishedDownload = () -> ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calculateDietary()
    }
    
    override func viewDidAppear(_ animated: Bool){
        foodListTable?.reloadData()
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
    
    @IBAction func searchMealProducts(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailFoodVC = storyboard.instantiateViewController(withIdentifier:"SearchMealProductsListViewController") as! SearchMealProductsViewController;()
        detailFoodVC.Mealfoodlist = Mealfoodlist
        self.navigationController?.pushViewController(detailFoodVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Mealfoodlist.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self.kcal = 0.0
            self.fiberMeal = 0.0
            self.vochtMeal  = 0.0
            self.pottassiumMeal = 0.0
            self.sodiumMeal = 0.0
            self.proteinMeal  = 0.0
            self.calculateDietary()
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func calculateDietary(){
        
        if(Mealfoodlist.count > 0){
            for food in Mealfoodlist {
                kcal += food.foodMealComponent!.kcal
                fiberMeal += food.foodMealComponent!.fiber
                vochtMeal += food.foodMealComponent!.water
                pottassiumMeal += food.foodMealComponent!.potassium
                proteinMeal +=  food.foodMealComponent!.protein
                sodiumMeal += food.foodMealComponent!.sodium
                
            }
            let kcalText:String = String(format:"%.1f", kcal)
            calorieResultLbl.text = kcalText
            
            let fiberText:String = String(format:"%.1f", fiberMeal)
            fiberResultLbl.text = fiberText
            
            let vochtText:String = String(format:"%.1f", vochtMeal)
            waterResultLbl.text = vochtText
            
            let pottassiumText:String = String(format:"%.1f", pottassiumMeal)
            potassiumResultLbl.text = pottassiumText
            
            let proteinText:String = String(format:"%.1f", proteinMeal)
            proteinResultLbl.text = proteinText
            
            let sodiumText:String = String(format:"%.1f", sodiumMeal)
            sodiumResultLbl.text = sodiumText
        }
        else{
            calorieResultLbl.text = "0.0"
            fiberResultLbl.text = "0.0"
            waterResultLbl.text = "0.0"
            potassiumResultLbl.text = "0.0"
            proteinResultLbl.text = "0.0"
            sodiumResultLbl.text = "0.0"
        }
    }
    
    func addMeal() {
        let weight = self.createNewWeight(id: 8, unit: "", short: "", createdAt: "", updatedAt: "")
        
        let patient = self.createNewPatient(id: 1, gender: "", createdAt: "", updatedAt: "", doctor: 0, user: 0)
        
        let kcalFloat = (calorieResultLbl.text as! NSString).floatValue
        
        let foodMealComponent = self.createNewFoodMealComponent(id: 0, name: self.nameInput.text!, description: "Self made meal", kcal: kcal, protein: proteinMeal, potassium: pottassiumMeal, sodium: sodiumMeal, water: vochtMeal, fiber: fiberMeal, portionSize: 1, imageUrl: "https://image.flaticon.com/icons/png/512/45/45332.png")
        
        let meal = self.createNewMealObject(id: 0, weightUnit: weight, patient: patient, foodMealComponent: foodMealComponent, mealFoods: self.newMealFoodList)
        

        NiZiAPIHelper.createMeal(withToken: KeychainWrapper.standard.string(forKey: "authToken")!, withDetails: meal, withPatient: 1).responseData(completionHandler: { response in
            
            guard let jsonResponse = response.data
                else { print("temp1"); return }
            
            let jsonDecoder = JSONDecoder()
            guard let mealJSON = try? jsonDecoder.decode( NewMeal.self, from: jsonResponse )
                else { print("temp2"); return }
            
            self.createdMeal = mealJSON
            print("----------------------------")
            print(self.createdMeal?.id)
        })
    }
    
    func createHelperId(id : Int) -> HelperId {
        let helperId : HelperId = HelperId(id: id)
        return helperId
    }
    
    func createNewMealObject(id: Int, weightUnit: newWeightUnit, patient: NewPatient, foodMealComponent: newFoodMealComponent, mealFoods: [NewMealFood]) -> NewMeal {
        
        let meal : NewMeal = NewMeal(id: id, weightUnit: weightUnit, patient: patient, foodMealComponent: foodMealComponent, mealFoods: mealFoods)
        return meal
    }
    
    func createNewWeight(id: Int, unit : String, short : String, createdAt: String, updatedAt : String) -> newWeightUnit {
        let consumptionWeight : newWeightUnit = newWeightUnit(id: id, unit: unit, short: short, createdAt: createdAt, updatedAt: updatedAt)
        return consumptionWeight
    }
    
    func createNewPatient(id: Int, gender : String, createdAt : String, updatedAt : String, doctor : Int, user : Int) -> NewPatient {
        let consumptionPatient : NewPatient = NewPatient(id: id, gender: gender, dateOfBirth: "", createdAt: createdAt, updatedAt: updatedAt, doctor: doctor, user: user)
        return consumptionPatient
    }
    
    func createNewFoodMealComponent(id: Int, name: String, description: String, kcal: Float, protein: Float, potassium: Float, sodium: Float, water: Float, fiber: Float, portionSize: Float, imageUrl: String) -> newFoodMealComponent {
        
        let foodmealComponent : newFoodMealComponent = newFoodMealComponent(id: id, name: name, description: description, kcal: kcal, protein: protein, potassium: potassium, sodium: sodium, water: water, fiber: fiber, portionSize: portionSize, imageUrl: imageUrl)
        return foodmealComponent
    }
    
    
    func addMealProducts(){
        
        let mealId = createdMeal?.id
        
        for product in self.Mealfoodlist {
            NiZiAPIHelper.addMealFood(withToken: KeychainWrapper.standard.string(forKey: "authToken")!, withFoods: product.id!, withMeal: mealId!, withAmount: 1).responseData(completionHandler: { response in
                
                guard let jsonResponse = response.data
                    else { print("temp1"); return }
            })
        }
    }
    
    @IBAction func importProducts(_ sender: Any) {
        // Needs to be done later on
    }
    
    @IBAction func saveMeal(_ sender: Any) {
        addMeal()
        //addMealProducts()
        /*
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailFoodVC = storyboard.instantiateViewController(withIdentifier:"MealSearchViewController") as! MealSearchViewController;()
        self.navigationController?.pushViewController(detailFoodVC, animated: true)
 */
    }
    
    
}
