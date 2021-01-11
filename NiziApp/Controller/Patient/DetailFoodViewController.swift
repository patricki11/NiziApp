//
//  DetailFoodViewController.swift
//  NiziApp
//
//  Created by Samir Yeasin on 04/01/2021.
//  Copyright © 2021 Samir Yeasin. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Kingfisher

class DetailFoodViewController: UIViewController {
    
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
    @IBOutlet weak var datepicker: UIDatePicker!
    @IBOutlet weak var mealEditBtn: UIButton!
    
    var foodItem        : newFoodMealComponent?
    var patient         : NewPatient?
    var weightUnit      : newWeightUnit?
    var food            : NewFood?
    var meal            : NewMeal?
    var favorite        : NewFavoriteShort?
    var Mealfoodlist    : [NewFood] = []
    var foodlist        : [NewFavorite] = []
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
    var foodObject      : NewFood?
    var foodTime        : String = KeychainWrapper.standard.string(forKey: "mealTime")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetupData()
    }
    
    @IBAction func AddToDiary(_ sender: Any) {
        if let floatValue = Float(portionSizeInput.text!) {
            if floatValue > 0.1{
                amount = floatValue
                if(isMealProductDetail == true){
                    self.addProductToMealList()
                }else{
                    addConsumption()
                }
            } else {
                displayAlertMessage(title: "Portie fout", message: "Portie waarde is onjuist",location: "" )
            }
        }else{
            displayAlertMessage(title: "Portie fout", message: "Portie waarde is onjuist",location: "" )
        }
    }
    
    @IBAction func AddtoFavorites(_ sender: Any) {
        Addfavorite()
    }
    
    @IBAction func goToEditMeal(_ sender: Any) {
        self.navigateToEditMeal()
    }
    
    @IBAction func deleteBtn(_ sender: Any) {
        if(isMealDetail){
            deleteMealCall()
        }else{
            deleteConsumptionCall()
        }
    }
    
    @IBAction func minusAction(_ sender: Any) {
        let str = portionSizeInput.text ?? "1.0"
        if var mFloat = Float(str) {
            mFloat -= 0.5
            if mFloat > 0 {
                portionSizeInput.text = mFloat.description
                self.SetupData()
            }
        }
    }
    
    @IBAction func plusAction(_ sender: Any) {
        let str = portionSizeInput.text ?? "1.0"
        if var mFloat = Float(str) {
            mFloat += 0.5
            portionSizeInput.text = mFloat.description
            self.SetupData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(isMealProductDetail){
            self.navigationController?.setNavigationBarHidden(false, animated: animated)
        }else{
            self.navigationController?.setNavigationBarHidden(false, animated: animated)
        }
    }
    
    func SetupData()
    {
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
        
        DetailTitle.text = self.foodItem!.name
        
        let url = URL(string: self.foodItem!.imageUrl)
        Picture.kf.setImage(with: url)
        
        let str = portionSizeInput.text ?? "1.0"
        if var mFloat = Float(str) {
            if mFloat > 0 {
                let calorieString : String = String(format:"%.1f", self.foodItem!.kcal * mFloat)
                Kcal.text = calorieString + " " + "Kcal"
                
                let proteinString : String = String(format:"%.1f", self.foodItem!.protein * mFloat)
                Protein.text = proteinString + " " + "g"
                
                let fiberString : String = String(format:"%.1f", self.foodItem!.fiber * mFloat)
                Fiber.text = fiberString + " " + "g"
                
                let calciumString : String = String(format:"%.1f", self.foodItem!.potassium * mFloat)
                Calcium.text = calciumString + " " + "mg"
                
                let sodiumString : String = String(format:"%.1f", self.foodItem!.sodium * mFloat)
                Sodium.text = sodiumString + " " + " mg"
                
                let waterString : String = String(format:"%.1f", self.foodItem!.water * mFloat)
                WaterLabel.text = waterString + " " + "g"
                
                let portionSizeString : String = String(self.foodItem!.portionSize * mFloat)
                portionSizeLabel.text = portionSizeString
            }
        }

        switch foodTime {
        case "Ontbijt":
            MealTime.selectedSegmentIndex = 0
            break
        case "Lunch":
            MealTime.selectedSegmentIndex = 1
            break
        case "Avondeten":
            MealTime.selectedSegmentIndex = 2
            break
        case "Snack":
            MealTime.selectedSegmentIndex = 3
        default:
            break
        }
        
        self.checkIfFavoriteCall()
    }
    
    func Addfavorite() {
        if(self.foodlist.count >= 1){
            deleteFavorteCall()
        }
        else{
            addFavoriteCall()
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
            
            let foodComponent = self.createNewFoodMealComponent(id:foodItem!.id, name: foodItem!.name, description: foodItem!.description, kcal: foodItem!.kcal, protein: foodItem!.protein, potassium: foodItem!.potassium, sodium: foodItem!.sodium, water: foodItem!.water, fiber: foodItem!.fiber, portionSize: foodItem!.portionSize, imageUrl: foodItem!.imageUrl, foodId: foodItem!.foodId)
            
            if(self.weightUnit?.id == nil){
                self.weightId = 8
            }
            else {
                self.weightId = self.weightUnit!.id
            }
            
            let weight = self.createNewWeight(id: self.weightId, unit: "", short: "", createdAt: "", updatedAt: "")
            
            let patient = self.createNewPatient(id: patientId!)
            
            let consumption = self.createNewConsumptionObject(amount: self.amount, date: KeychainWrapper.standard.string(forKey: "date")!, mealTime: self.mealtimeString, patient: patient, weightUnit: weight, foodMealComponent: foodComponent)
            
            createConsumptionCall(consumption: consumption)
        }
        else{
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let selectedDate: String = dateFormatter.string(from: datepicker.date)
            let finalDate = selectedDate + "T00:00:00.000Z"
            
            let patchConsumption = self.createPatchConsumption(amount: self.amount, date: finalDate, mealTime: self.mealtimeString)
            
            editConsumption(consumption: patchConsumption)
        }
    }
    
    func addProductToMealList() {
        var productExist = false
        
        for product in Mealfoodlist {
            if(product.id == food?.id){
                productExist = true
            }
        }
        
        food?.amount = Float(portionSizeInput.text!)
        
        if(productExist == false){
            Mealfoodlist.append(food!)
        }
        self.displayAlertMessage(title: NSLocalizedString("Sucess", comment: ""), message: "Voedsel is toegevoegd aan maaltijd", location: "toMealProduct")
    }
    
    func displayAlertMessage(title:String, message: String, location: String){
        let alertController = UIAlertController(title: NSLocalizedString(title, comment: "Title"),message: NSLocalizedString(message, comment: "Message"),preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Ok"), style: .default, handler: {action in
            switch location {
            case "toMeal":
                self.navigateToMeal()
                break
            case "toDiary":
                self.navigateToDiary()
                break
            case "toMealProduct":
                self.navigateSearchMealProduct()
                break
            case "Favorite":
                self.SetupData()
                break
            default:
                break
            }
        }))
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
        let detailFoodVC = storyboard.instantiateViewController(withIdentifier:"NewCreateMealViewController") as! NewCreateMealViewController;()
        detailFoodVC.editMeal = true
        detailFoodVC.editMealObject = self.meal
        detailFoodVC.editMealsHasbeenRetrieved = false
        self.navigationController?.pushViewController(detailFoodVC, animated: true)
    }
    
    func navigateSearchMealProduct(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailFoodVC = storyboard.instantiateViewController(withIdentifier:"SearchMealProductsListViewController") as! SearchMealProductsViewController;()
        detailFoodVC.Mealfoodlist = self.Mealfoodlist
        if(self.editMeal){
            detailFoodVC.editMeal = true
            detailFoodVC.editMealObject = self.editMealObject
            detailFoodVC.editMealsHasbeenRetrieved = true
        }
        self.navigationController?.pushViewController(detailFoodVC, animated: true)
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
    
    func createNewFoodMealComponent(id: Int, name: String, description: String, kcal: Float, protein: Float, potassium: Float, sodium: Float, water: Float, fiber: Float, portionSize: Float, imageUrl: String, foodId : Int) -> newFoodMealComponent {
        let foodmealComponent : newFoodMealComponent = newFoodMealComponent(id: id, name: name, description: description, kcal: kcal, protein: protein, potassium: potassium, sodium: sodium, water: water, fiber: fiber, portionSize: portionSize, imageUrl: imageUrl, foodId: foodId)
        return foodmealComponent
    }
    
    //MARK: API CALLS
    
    //Favorites
    func addFavoriteCall(){
        NiZiAPIHelper.addMyFood(withToken:KeychainWrapper.standard.string(forKey: "authToken")! , withPatientId: KeychainWrapper.standard.string(forKey: "patientId")!, withFoodId: (self.foodObject?.id)!).responseData(completionHandler: { response in
            self.displayAlertMessage(title: NSLocalizedString("Sucess", comment: ""), message: NSLocalizedString("FavoriteHasBeenAdded", comment: ""), location: "Favorite")
        })
    }
    
    func deleteFavorteCall(){
        NiZiAPIHelper.deleteFavorite(withToken: KeychainWrapper.standard.string(forKey: "authToken")! , withConsumptionId: self.foodlist[0].id!).responseData(completionHandler: { response in
            self.displayAlertMessage(title: NSLocalizedString("Sucess", comment: ""), message: NSLocalizedString("FavoriteHasBeenDeleted", comment: ""), location: "Favorite")
        })
        
    }
    
    func checkIfFavoriteCall(){
        NiZiAPIHelper.searchOneFoodFavorite(withToken: KeychainWrapper.standard.string(forKey: "authToken")!, withFood: foodItem!.foodId, withPatient: KeychainWrapper.standard.string(forKey: "patientId")!).responseData(completionHandler: { response in
            
            guard let jsonResponse = response.data
            else { print("temp1"); return }
            
            let jsonDecoder = JSONDecoder()
            guard let foodlistJSON = try? jsonDecoder.decode( [NewFavorite].self, from: jsonResponse )
            else { print("temp2"); return }
            
            self.foodlist = foodlistJSON
            
            if(self.foodlist.count >= 1){
                self.favoriteBtn.setImage(UIImage(named: "HeartFilled2_s"), for: .normal)
            }
            else{
                self.favoriteBtn.setImage(UIImage(named: "Heart2_s"), for: .normal)
            }
        })
    }
    
    //Consumption
    func createConsumptionCall(consumption : NewConsumptionModel){
        NiZiAPIHelper.addNewConsumption(withToken: KeychainWrapper.standard.string(forKey: "authToken")!, withDetails: consumption).responseData(completionHandler: { response in
            self.displayAlertMessage(title: NSLocalizedString("Sucess", comment: ""), message: NSLocalizedString("FoodHasBeenAdded", comment: ""), location: "")
        })
    }
    
    func editConsumption(consumption : NewConsumptionPatch){
        NiZiAPIHelper.patchNewConsumption(withToken: KeychainWrapper.standard.string(forKey: "authToken")!, withDetails: consumption, withConsumptionId: self.consumptionId).responseData(completionHandler: { response in
            self.displayAlertMessage(title: NSLocalizedString("Sucess", comment: ""), message: NSLocalizedString("FoodEdited", comment: ""), location: "toDiary")
        })
    }
    
    func deleteConsumptionCall(){
        NiZiAPIHelper.deleteConsumption2(withToken: KeychainWrapper.standard.string(forKey: "authToken")!, withConsumptionId: consumptionId).responseData(completionHandler: { response in
            self.displayAlertMessage(title: NSLocalizedString("Sucess", comment: ""), message: NSLocalizedString("FoodDeleted", comment: ""), location: "toDiary")
        })
    }
    
    // Meal
    func deleteMealCall(){
        NiZiAPIHelper.deleteMeal(withToken: KeychainWrapper.standard.string(forKey: "authToken")!, withMealId: meal!.id).responseData(completionHandler: { response in
            self.displayAlertMessage(title: NSLocalizedString("Sucess", comment: ""), message: NSLocalizedString("MealDeletedConfirmed", comment: ""), location: "toMeal")
        })
    }
    
}

extension DetailFoodViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        (viewController as? SearchMealProductsViewController)?.Mealfoodlist = Mealfoodlist
    }
}


