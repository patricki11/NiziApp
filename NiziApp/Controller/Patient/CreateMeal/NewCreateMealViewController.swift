//
//  NewCreateMealViewController.swift
//  NiziApp
//
//  Created by Samir Yeasin on 11/01/2021.
//  Copyright © 2021 Samir Yeasin. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class NewCreateMealViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CartSelection {

    func addProductToCart(product: NewFood, atindex: Int) {
        Mealfoodlist[atindex] = product
        for product in Mealfoodlist {
            print(product.foodMealComponent?.portionSize)
        }
        self.calculateDietary()
        foodListTable.reloadData()
    }
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var foodListTable: UITableView!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var searchFoodBtn: UIButton!
    //@IBOutlet weak var importBtn: UIButton!
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
    var editMeal        : Bool = false
    var editMealObject  : NewMeal?
    let patientIntID    : Int = Int(KeychainWrapper.standard.string(forKey: "patientId")!)!
    var retrievedFoodItem: NewFood?
    var mealId          : Int = 0
    var editMealsHasbeenRetrieved : Bool = false

    typealias FinishedDownload = () -> ()
    
    @IBOutlet weak var deleteBtn: UIButton!
    @IBAction func deleteMeal(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(editMealsHasbeenRetrieved == false){
            if(editMeal){
                self.getProducts()
                self.editMealsHasbeenRetrieved = true
            }
        }
        self.calculateDietary()
    }

    override func viewDidAppear(_ animated: Bool){
        foodListTable?.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Mealfoodlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let productsMealCell = tableView.dequeueReusableCell(withIdentifier: "MealProductsCell", for: indexPath) as! MealProductsTableViewCell
        let idx: Int = indexPath.row
        productsMealCell.titleLbl.text = Mealfoodlist[idx].foodMealComponent?.name
        let portionSizeString : String = String(format:"%.f",Mealfoodlist[idx].foodMealComponent?.portionSize as! CVarArg)
        productsMealCell.subTitleLbl.text = ( portionSizeString + " " + (Mealfoodlist[idx].weightObject?.unit)!)
        productsMealCell.food = Mealfoodlist[indexPath.row]
        productsMealCell.index = indexPath.row
        productsMealCell.cartSelectionDelegate = self
        productsMealCell.amountInput.text = Mealfoodlist[idx].amount?.description
        return productsMealCell
    }
    
    @IBAction func searchMealProducts(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailFoodVC = storyboard.instantiateViewController(withIdentifier:"SearchMealProductsListViewController") as! SearchMealProductsViewController;()
        detailFoodVC.Mealfoodlist = Mealfoodlist
        if(editMeal){
            detailFoodVC.editMeal = true
            detailFoodVC.editMealObject = self.editMealObject
            detailFoodVC.editMealsHasbeenRetrieved = true
        }
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
        
        kcal = 0
        fiberMeal = 0
        vochtMeal = 0
        pottassiumMeal = 0
        proteinMeal = 0
        sodiumMeal = 0
        
        if(Mealfoodlist.count > 0){
            for food in Mealfoodlist {
                kcal += food.foodMealComponent!.kcal * food.amount!
                fiberMeal += food.foodMealComponent!.fiber * food.amount!
                vochtMeal += food.foodMealComponent!.water * food.amount!
                pottassiumMeal += food.foodMealComponent!.potassium * food.amount!
                proteinMeal +=  food.foodMealComponent!.protein * food.amount!
                sodiumMeal += food.foodMealComponent!.sodium * food.amount!
                
            }
            let kcalText:String = String(format:"%.1f", kcal)
            calorieResultLbl.text = kcalText + " " + "Kcal"
            
            let fiberText:String = String(format:"%.1f", fiberMeal)
            fiberResultLbl.text = fiberText + " " + "g"
            
            let vochtText:String = String(format:"%.1f", vochtMeal)
            waterResultLbl.text = vochtText + " " + "g"
            
            let pottassiumText:String = String(format:"%.1f", pottassiumMeal)
            potassiumResultLbl.text = pottassiumText + " " + "mg"
            
            let proteinText:String = String(format:"%.1f", proteinMeal)
            proteinResultLbl.text = proteinText + " " + "g"
            
            let sodiumText:String = String(format:"%.1f", sodiumMeal)
            sodiumResultLbl.text = sodiumText + " " + "mg"
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
        
        let patient = self.createNewPatient(id: self.patientIntID, gender: "", createdAt: "", updatedAt: "", doctor: 0, user: 0)
        
        let kcalFloat = (calorieResultLbl.text as! NSString).floatValue
        
        let foodMealComponent = self.createNewFoodMealComponent(id: 0, name: self.nameInput.text!, description: "Self made meal", kcal: kcal, protein: proteinMeal, potassium: pottassiumMeal, sodium: sodiumMeal, water: vochtMeal, fiber: fiberMeal, portionSize: 1, imageUrl: "https://static.thenounproject.com/png/1695234-200.png")
        
        let meal = self.createNewMealObject(id: 0, weightUnit: weight, patient: patient, foodMealComponent: foodMealComponent, mealFoods: self.newMealFoodList)
        

        NiZiAPIHelper.createMeal(withToken: KeychainWrapper.standard.string(forKey: "authToken")!, withDetails: meal, withPatient: self.patientIntID).responseData(completionHandler: { response in
            
            guard let jsonResponse = response.data
                else { print("temp1"); return }
            
            let jsonDecoder = JSONDecoder()
            guard let mealJSON = try? jsonDecoder.decode( NewMeal.self, from: jsonResponse )
                else { print("temp2"); return }
            
            self.createdMeal = mealJSON
            print("----------------------------")
            print(self.createdMeal?.id)
        })
        
        self.presentAlert()
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
        
        let foodmealComponent : newFoodMealComponent = newFoodMealComponent(id: id, name: name, description: description, kcal: kcal, protein: protein, potassium: potassium, sodium: sodium, water: water, fiber: fiber, portionSize: portionSize, imageUrl: imageUrl, foodId: 0)
        return foodmealComponent
    }
    
    func addMealProducts(){
        if(editMeal){
            self.mealId = editMealObject!.id
        }
        else{
            self.mealId = createdMeal!.id
        }

        for product in self.Mealfoodlist {
            NiZiAPIHelper.addMealFood(withToken: KeychainWrapper.standard.string(forKey: "authToken")!, withFoods: product.id!, withMeal: self.mealId, withAmount: product.amount!).responseData(completionHandler: { response in
                
                guard let jsonResponse = response.data
                    else { print("temp1"); return }
            })
        }
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailFoodVC = storyboard.instantiateViewController(withIdentifier:"MealSearchViewController") as! MealSearchViewController;()
        self.navigationController?.pushViewController(detailFoodVC, animated: true)
    }
    
    @IBAction func saveMeal(_ sender: Any) {
        if(editMeal){
            self.removeOldFoodItems()
            self.patchMeal()
        }
        else{
            addMeal()
        }
    }
    
    func presentAlert(){
        let alert = UIAlertController(title: "Succes", message: "Maaltijd is gemaakt", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
            self.addMealProducts()
        }))
        present(alert, animated: true)
    }
    
    func getProducts(){
        nameInput.text = editMealObject?.foodMealComponent.name
        
        for mealFood in editMealObject!.mealFoods {
            
            NiZiAPIHelper.getSingleFood(withToken: KeychainWrapper.standard.string(forKey: "authToken")!, withFood: mealFood.food).responseData(completionHandler: { response in
                
                guard let jsonResponse = response.data
                    else { print("temp1"); return }
                
                let jsonDecoder = JSONDecoder()
                guard let FoodItem = try? jsonDecoder.decode( NewFood.self, from: jsonResponse )
                    else { print("temp2"); return }
                
                self.retrievedFoodItem = FoodItem
                self.retrievedFoodItem?.amount = mealFood.amount
                self.Mealfoodlist.append(self.retrievedFoodItem!)
                self.foodListTable.reloadData()
                self.calculateDietary()
            })
        }
    }
    
    func removeOldFoodItems(){
        for mealFood in editMealObject!.mealFoods{
            NiZiAPIHelper.removeMealFood(withToken: KeychainWrapper.standard.string(forKey: "authToken")!, withFoods: mealFood.id).responseData(completionHandler: { response in
                print("Meal item is deleted")
            })
        }
    }
    
    func patchMeal(){
        let foodMealComponent = self.createNewFoodMealComponent(id: self.editMealObject!.foodMealComponent.id, name: self.nameInput.text!, description: "Self made meal", kcal: kcal, protein: proteinMeal, potassium: pottassiumMeal, sodium: sodiumMeal, water: vochtMeal, fiber: fiberMeal, portionSize: 1, imageUrl: "https://static.thenounproject.com/png/1695234-200.png")
        
        NiZiAPIHelper.patchMeal(withToken: KeychainWrapper.standard.string(forKey: "authToken")!, withDetails: foodMealComponent, withMeal: self.editMealObject!.id).responseData(completionHandler: { response in
            print("Meal item is being patched")
        })
        
        self.presentPatchAlert()
    }
    
    func presentPatchAlert(){
        let alert = UIAlertController(title: "Success", message: "Maaltijd is aangepast", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
            self.addMealProducts()
        }))
        present(alert, animated: true)
    }
    
    
    

}
