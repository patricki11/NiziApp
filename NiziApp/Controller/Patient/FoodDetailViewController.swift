//
//  FoodDetailViewController.swift
//  NiziApp
//
//  Created by Wing lam on 23/12/2019.
//  Copyright © 2019 Samir Yeasin. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Kingfisher

class FoodDetailViewController: UIViewController {
    @IBOutlet weak var DetailTitle: UILabel!
    @IBOutlet weak var Portion: UILabel!
    @IBOutlet weak var Kcal: UILabel!
    @IBOutlet weak var Protein: UILabel!
    @IBOutlet weak var Fiber: UILabel!
    @IBOutlet weak var Calcium: UILabel!
    @IBOutlet weak var Sodium: UILabel!
    @IBOutlet weak var Picture: UIImageView!
    @IBOutlet weak var portionSizeLabel: UILabel!
    @IBOutlet weak var WaterLabel: UILabel!
    @IBOutlet weak var MealTime: UISegmentedControl!
    @IBOutlet weak var trashBtn: UIButton!
    @IBOutlet weak var favoriteBtn: UIButton!
    
    @IBOutlet weak var mealSearchBtn: UIButton!
    @IBOutlet weak var mealSaveBtn: UIButton!
    
    
    var foodItem: newFoodMealComponent?
    var patient : NewPatient?
    var weightUnit : newWeightUnit?
    var food : NewFood?
    var Mealfoodlist : [NewFood] = []
    var mealtimeString: String = ""
    var consumptionId : Int = 0
    var isDiaryDetail : Bool = false
    var isMealDetail : Bool = false
    var isMealProductDetail : Bool = false
    
    
    
    @IBAction func AddToDiary(_ sender: Any) {
        if(isMealProductDetail == true){
            self.addProductToMealList()
        }else{
            addConsumption()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    
    
    func SetupData()
    {
        mealSearchBtn.isHidden = true
        mealSaveBtn.isHidden = true
        
        if(isDiaryDetail == false){
            trashBtn.isHidden = true
        }
        
        if(isMealDetail){
            favoriteBtn.isHidden = true
        }
        
        if(isMealProductDetail){
            mealSearchBtn.isHidden = false
            mealSaveBtn.isHidden = false
        }
        
        DetailTitle.text = foodItem?.name
        
        let url = URL(string: foodItem!.imageUrl)
        Picture.kf.setImage(with: url)
        
        let calorieString : String = (foodItem!.protein.description)
        Kcal.text = calorieString
        
        let proteinString : String = (foodItem!.kcal.description)
        Protein.text = proteinString
        
        let fiberString : String = (foodItem!.fiber.description)
        Fiber.text = fiberString
        
        let calciumString : String = (foodItem!.protein.description)
        Calcium.text = calciumString
        
        let sodiumString : String = (foodItem!.sodium.description)
        Sodium.text = sodiumString
        
        let portionSizeString : String = (foodItem!.portionSize.description)
        portionSizeLabel.text = portionSizeString
        
        let waterString : String = (foodItem!.water.description)
        WaterLabel.text = waterString
        
    }
    @IBAction func AddtoFavorites(_ sender: Any) {
        Addfavorite()
        
    }
    
    func Addfavorite() {
        /*
         NiZiAPIHelper.addProductToFavorite(forproductId: foodItem!.foodId, forPatient: patientIntID!, authenticationCode: KeychainWrapper.standard.string(forKey: "authToken")!).responseString(completionHandler: {response in
         guard let jsonResponse = response.request
         else { print("Not succeeded"); return }
         print(response.request)
         })
         */
    }
    func addConsumption() {
        switch MealTime.selectedSegmentIndex {
        case 0:
            mealtimeString = "Ontbijt"
            break
        case 1:
            mealtimeString = "Lunch"
            break
        case 2:
            mealtimeString = "Avondeten"
            break
        case 3:
            mealtimeString = "Snack"
        default:
            break
        }
        
        if(isDiaryDetail == false){
            
            let foodComponent = self.createNewFoodMealComponent(id: foodItem!.id, name: foodItem!.name, description: foodItem!.description, kcal: foodItem!.kcal, protein: foodItem!.protein, potassium: foodItem!.potassium, sodium: foodItem!.sodium, water: foodItem!.water, fiber: foodItem!.fiber, portionSize: foodItem!.portionSize, imageUrl: foodItem!.imageUrl)
            
            let weight = self.createNewWeight(id: self.weightUnit!.id, unit: self.weightUnit!.unit, short: self.weightUnit!.short, createdAt: self.weightUnit!.createdAt, updatedAt: self.weightUnit!.updatedAt)
            
            let patient = self.createNewPatient(id: 1)
            
            let consumption = self.createNewConsumptionObject(amount: 1, date: "2020-11-18T00:00:00.000Z", mealTime: self.mealtimeString, patient: patient, weightUnit: weight, foodMealComponent: foodComponent)
            
            NiZiAPIHelper.addNewConsumption(withToken: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiaWF0IjoxNjA1MTA0Njk3LCJleHAiOjE2MDc2OTY2OTd9.VQqpsXC4IrdPjcNE9cuMpwumiLncAKorGB8eIDAWS2Y", withDetails: consumption).responseData(completionHandler: { response in
                let alertController = UIAlertController(
                    title: NSLocalizedString("Success", comment: "Title"),
                    message: NSLocalizedString("Voedsel is toegevoegd", comment: "Message"),
                    preferredStyle: .alert)
                
                alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Ok"), style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            })
        }
        else{
            let patchConsumption = self.createPatchConsumption(amount: 1.0, date: "2020-11-18T00:00:00.000Z", mealTime: self.mealtimeString)
            
            NiZiAPIHelper.patchNewConsumption(withToken: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiaWF0IjoxNjA1MTA0Njk3LCJleHAiOjE2MDc2OTY2OTd9.VQqpsXC4IrdPjcNE9cuMpwumiLncAKorGB8eIDAWS2Y", withDetails: patchConsumption, withConsumptionId: self.consumptionId).responseData(completionHandler: { response in
                let alertController = UIAlertController(
                    title: NSLocalizedString("Success", comment: "Title"),
                    message: NSLocalizedString("Voedsel is gewijzigd", comment: "Message"),
                    preferredStyle: .alert)
                
                alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Ok"), style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            })
        }
    }
    
    func createNewPatient(id: Int) -> PatientConsumption {
        let consumptionPatient : PatientConsumption = PatientConsumption(id: id)
        return consumptionPatient
    }
    
    func createPatchConsumption(amount: Float, date: String, mealTime : String) -> NewConsumptionPatch {
        let patchConsumption : NewConsumptionPatch = NewConsumptionPatch(amount: amount, date: date, mealTime: mealTime)
        return patchConsumption
    }
    
    func createNewConsumptionObject(amount: Float, date: String, mealTime: String, patient: PatientConsumption, weightUnit: newWeightUnit, foodMealComponent: newFoodMealComponent) -> NewConsumptionModel {
        
        let consumption : NewConsumptionModel = NewConsumptionModel(amount: amount, date: date, mealTime: mealTime, weightUnit: weightUnit, foodmealComponent: foodMealComponent, patient: patient)
        return consumption
    }
    
    func createNewWeight(id: Int, unit : String, short : String, createdAt: String, updatedAt : String) -> newWeightUnit {
        let consumptionWeight : newWeightUnit = newWeightUnit(id: id, unit: unit, short: short, createdAt: createdAt, updatedAt: updatedAt)
        return consumptionWeight
    }
    
    func createNewFoodMealComponent(id: Int, name: String, description: String, kcal: Float, protein: Float, potassium: Float, sodium: Float, water: Float, fiber: Float, portionSize: Float, imageUrl: String) -> newFoodMealComponent {
        
        let foodmealComponent : newFoodMealComponent = newFoodMealComponent(id: id, name: name, description: description, kcal: kcal, protein: protein, potassium: potassium, sodium: sodium, water: water, fiber: fiber, portionSize: portionSize, imageUrl: imageUrl)
        return foodmealComponent
    }
    
    @IBAction func deleteBtn(_ sender: Any) {
        NiZiAPIHelper.deleteConsumption2(withToken: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiaWF0IjoxNjA1MTA0Njk3LCJleHAiOjE2MDc2OTY2OTd9.VQqpsXC4IrdPjcNE9cuMpwumiLncAKorGB8eIDAWS2Y", withConsumptionId: consumptionId).responseData(completionHandler: { response in
            let alertController = UIAlertController(
                title: NSLocalizedString("Success", comment: "Title"),
                message: NSLocalizedString("Voedsel is verwijdert", comment: "Message"),
                preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Ok"), style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        })
    }
    
    func addProductToMealList() {
        Mealfoodlist.append(food!)
        let alertController = UIAlertController(
            title: NSLocalizedString("Success", comment: "Title"),
            message: NSLocalizedString("Voedsel is toegevoegd aan maaltijd", comment: "Message"),
            preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Ok"), style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func backToMealSearch(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailFoodVC = storyboard.instantiateViewController(withIdentifier:"SearchMealProductsListViewController") as! SearchMealProductsViewController;()
        detailFoodVC.Mealfoodlist = Mealfoodlist
        self.navigationController?.pushViewController(detailFoodVC, animated: true)
    }
    
    
    @IBAction func SaveMeal(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailFoodVC = storyboard.instantiateViewController(withIdentifier:"MealCreateViewController") as! MealCreateViewController;()
        detailFoodVC.Mealfoodlist = Mealfoodlist
        self.navigationController?.pushViewController(detailFoodVC, animated: true)
    }
    
}


