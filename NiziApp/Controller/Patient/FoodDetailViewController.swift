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
    @IBOutlet weak var portionSizeInput: UITextField!
    @IBOutlet weak var mealSearchBtn: UIButton!
    @IBOutlet weak var mealSaveBtn: UIButton!
    @IBOutlet weak var datepicker: UIDatePicker!
    @IBOutlet weak var mealEditBtn: UIButton!
    
    
    
    var foodItem        : newFoodMealComponent?
    var patient         : NewPatient?
    var weightUnit      : newWeightUnit?
    var food            : NewFood?
    var meal            : NewMeal?
    var favorite        : NewFavoriteShort?
    var Mealfoodlist    : [NewFood] = []
    var patientList     : [ApiHelper] = []
    var mealtimeString  : String = ""
    var consumptionId   : Int = 0
    var isDiaryDetail   : Bool = false
    var isMealDetail    : Bool = false
    var isMealProductDetail : Bool = false
    var weightId        : Int = 0
    var amount          : Float = 0.0
    var editMealObject  : NewMeal?
    var editMeal        : Bool = false
    var editMealsHasbeenRetrieved : Bool = false
    var favoriteFood    : NewFood?
    
    
    @IBAction func AddToDiary(_ sender: Any) {
        if let floatValue = Float(portionSizeInput.text!) {
            amount = floatValue
            if(isMealProductDetail == true){
                self.addProductToMealList()
            }else{
                addConsumption()
            }
        } else {
            print("String does not contain Float")
            displayErrorMessage()
        }
    }
    
    @IBAction func backToMealSearch(_ sender: Any) {
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
    
    @IBAction func SaveMeal(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailFoodVC = storyboard.instantiateViewController(withIdentifier:"MealCreateViewController") as! MealCreateViewController;()
        detailFoodVC.Mealfoodlist = Mealfoodlist
        self.navigationController?.pushViewController(detailFoodVC, animated: true)
    }
    
    @IBAction func AddtoFavorites(_ sender: Any) {
        Addfavorite()
    }
    
    @IBAction func goToEditMeal(_ sender: Any) {
        self.navigateToEditMeal()
    }
    
    @IBAction func deleteBtn(_ sender: Any) {
        
        if(isMealDetail){
            NiZiAPIHelper.deleteMeal(withToken: KeychainWrapper.standard.string(forKey: "authToken")!, withMealId: meal!.id).responseData(completionHandler: { response in
                let alertController = UIAlertController(
                    title: NSLocalizedString("Success", comment: "Title"),
                    message: NSLocalizedString("Maaltijd is verwijdert", comment: "Message"),
                    preferredStyle: .alert)
                
                alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Ok"), style: .default, handler: {action in
                    self.navigateToMeal()
                }))
                self.present(alertController, animated: true, completion: nil)
            })
            
        }else{
            NiZiAPIHelper.deleteConsumption2(withToken: KeychainWrapper.standard.string(forKey: "authToken")!, withConsumptionId: consumptionId).responseData(completionHandler: { response in
                let alertController = UIAlertController(
                    title: NSLocalizedString("Success", comment: "Title"),
                    message: NSLocalizedString("Voedsel is verwijdert", comment: "Message"),
                    preferredStyle: .alert)
                
                alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Ok"), style: .default, handler: {action in
                    self.navigateToDiary()
                }))
                self.present(alertController, animated: true, completion: nil)
            })
        }
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the Navigation Bar
        if(isMealProductDetail){
            self.navigationController?.setNavigationBarHidden(true, animated: animated)
        }else{
            self.navigationController?.setNavigationBarHidden(false, animated: animated)
        }
        
    }
    
    func SetupData()
    {
        mealSearchBtn.isHidden = true
        mealSaveBtn.isHidden = true
        mealEditBtn.isHidden = true
        datepicker.isHidden = true
        trashBtn.isHidden = true
        
        if(isDiaryDetail){
            trashBtn.isHidden = false
            datepicker.isHidden = false
            favoriteBtn.isHidden = true
        }
        
        if(isMealDetail){
            favoriteBtn.isHidden = true
            trashBtn.isHidden = false
            mealEditBtn.isHidden = false
        }
        
        if(isMealProductDetail){
            mealSearchBtn.isHidden = false
            mealSaveBtn.isHidden = true
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
  
    
    func Addfavorite() {
        
        if(favorite?.id != nil){
            NiZiAPIHelper.deleteFavorite(withToken: KeychainWrapper.standard.string(forKey: "authToken")! , withConsumptionId: favorite!.id).responseData(completionHandler: { response in
                let alertController = UIAlertController(
                    title: NSLocalizedString("Success", comment: "Title"),
                    message: NSLocalizedString("Favoriet is verwijdert", comment: "Message"),
                    preferredStyle: .alert)
                
                alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Ok"), style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            })
        }
        else{
            let patientId = Int(KeychainWrapper.standard.string(forKey: "patientId")!)
            let patient = self.createApiHelper(id: patientId!)
            patientList.append(patient)

            
            NiZiAPIHelper.addMyFood(withToken:KeychainWrapper.standard.string(forKey: "authToken")! , withPatientId: self.patientList, withFoodId: (self.favoriteFood?.id)!).responseData(completionHandler: { response in
                let alertController = UIAlertController(
                    title: NSLocalizedString("Success", comment: "Title"),
                    message: NSLocalizedString("Favoriet is toegevoegd", comment: "Message"),
                    preferredStyle: .alert)
                
                alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Ok"), style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            })
        }

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
            
            let patientId = Int(KeychainWrapper.standard.string(forKey: "patientId")!)
            
            let foodComponent = self.createNewFoodMealComponent(id: foodItem!.id, name: foodItem!.name, description: foodItem!.description, kcal: foodItem!.kcal, protein: foodItem!.protein, potassium: foodItem!.potassium, sodium: foodItem!.sodium, water: foodItem!.water, fiber: foodItem!.fiber, portionSize: foodItem!.portionSize, imageUrl: foodItem!.imageUrl)
            
            
            if(self.weightUnit?.id == nil){
                self.weightId = 8
            }
            else {
                self.weightId = self.weightUnit!.id
            }
            
            let weight = self.createNewWeight(id: self.weightId, unit: "", short: "", createdAt: "", updatedAt: "")
            
            let patient = self.createNewPatient(id: patientId!)
            
            let consumption = self.createNewConsumptionObject(amount: self.amount, date: KeychainWrapper.standard.string(forKey: "date")!, mealTime: self.mealtimeString, patient: patient, weightUnit: weight, foodMealComponent: foodComponent)
            
            NiZiAPIHelper.addNewConsumption(withToken: KeychainWrapper.standard.string(forKey: "authToken")!, withDetails: consumption).responseData(completionHandler: { response in
                let alertController = UIAlertController(
                    title: NSLocalizedString("Success", comment: "Title"),
                    message: NSLocalizedString("Voedsel is toegevoegd", comment: "Message"),
                    preferredStyle: .alert)
                
                alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Ok"), style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            })
        }
        else{
            
            let dateFormatter: DateFormatter = DateFormatter()
            
            // Set date format
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            // Apply date format
            let selectedDate: String = dateFormatter.string(from: datepicker.date)
            let finalDate = selectedDate + "T00:00:00.000Z"
            
            let patchConsumption = self.createPatchConsumption(amount: self.amount, date: finalDate, mealTime: self.mealtimeString)
            
            NiZiAPIHelper.patchNewConsumption(withToken: KeychainWrapper.standard.string(forKey: "authToken")!, withDetails: patchConsumption, withConsumptionId: self.consumptionId).responseData(completionHandler: { response in
                let alertController = UIAlertController(
                    title: NSLocalizedString("Success", comment: "Title"),
                    message: NSLocalizedString("Voedsel is gewijzigd", comment: "Message"),
                    preferredStyle: .alert)
                
                alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Ok"), style: .default, handler: {action in
                    self.navigateToDiary()
                }))
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
    
    func createApiHelper(id : Int) -> ApiHelper{
        let helper : ApiHelper = ApiHelper(id: id)
        return helper
    }
    
    func addProductToMealList() {
        var productExist = false
        
        for product in Mealfoodlist {
            if(product.id == food?.id){
                productExist = true
            }
        }
        
        if(productExist == false){
            Mealfoodlist.append(food!)
        }
 
        let alertController = UIAlertController(
            title: NSLocalizedString("Success", comment: "Title"),
            message: NSLocalizedString("Voedsel is toegevoegd aan maaltijd", comment: "Message"),
            preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Ok"), style: .default, handler: {action in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let detailFoodVC = storyboard.instantiateViewController(withIdentifier:"SearchMealProductsListViewController") as! SearchMealProductsViewController;()
            detailFoodVC.Mealfoodlist = self.Mealfoodlist
            if(self.editMeal){
                detailFoodVC.editMeal = true
                detailFoodVC.editMealObject = self.editMealObject
                detailFoodVC.editMealsHasbeenRetrieved = true
            }
        
            self.navigationController?.pushViewController(detailFoodVC, animated: true)
        }))
        self.present(alertController, animated: true, completion: nil)
        
   
    }
    
    func displayErrorMessage(){
        let alertController = UIAlertController(
            title: NSLocalizedString("Error", comment: "Title"),
            message: NSLocalizedString("Portie waarde klopt niet", comment: "Message"),
            preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Ok"), style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func navigateToMeal(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailFoodVC = storyboard.instantiateViewController(withIdentifier:"MealSearchViewController") as! MealSearchViewController;()
        self.navigationController?.pushViewController(detailFoodVC, animated: true)
    }
    
    func navigateToDiary(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailFoodVC = storyboard.instantiateViewController(withIdentifier:"DairyViewController") as! DiaryViewController;()
        self.navigationController?.pushViewController(detailFoodVC, animated: true)
        
    }
    
    func navigateToEditMeal(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailFoodVC = storyboard.instantiateViewController(withIdentifier:"MealCreateViewController") as! MealCreateViewController;()
        detailFoodVC.editMeal = true
        detailFoodVC.editMealObject = self.meal
        detailFoodVC.editMealsHasbeenRetrieved = false
        self.navigationController?.pushViewController(detailFoodVC, animated: true)
        
    }
    
}


