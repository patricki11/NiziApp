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
    var mealtimeString: String = ""
    var foodItem: newFoodMealComponent?
    var patient : NewPatient?
    var weightUnit : newWeightUnit?
    //let patientIntID : Int? = Int(KeychainWrapper.standard.string(forKey: "patientId")!)
    
    @IBAction func AddToDiary(_ sender: Any) {
        addConsumption()
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
        
        let foodComponent = self.createNewFoodMealComponent(id: foodItem!.id, name: foodItem!.name, description: foodItem!.description, kcal: 0.0, protein: 0.0, potassium: 0.0, sodium: 0.0, water: 0.0, fiber: 0.0, portionSize: 1.0, imageUrl: foodItem!.imageUrl)
        
        let weight = self.createNewWeight(id: self.weightUnit!.id, unit: self.weightUnit!.unit, short: self.weightUnit!.short, createdAt: self.weightUnit!.createdAt, updatedAt: self.weightUnit!.updatedAt)
        
        let patient = self.createNewPatient(id: 1)
        
        let consumption = self.createNewConsumptionObject(amount: 1, date: "2020-11-18T00:00:00.000Z", mealTime: self.mealtimeString, patient: patient, weightUnit: weight, foodMealComponent: foodComponent)
        
        print(consumption.patient.toJSON())
        print(consumption.weightUnit.toJSON())
        print(consumption.foodmealComponent.toJSON())
        print("Final: ", consumption.toJSON())
        
        
        NiZiAPIHelper.addNewConsumption(withToken: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiaWF0IjoxNjA1MTA0Njk3LCJleHAiOjE2MDc2OTY2OTd9.VQqpsXC4IrdPjcNE9cuMpwumiLncAKorGB8eIDAWS2Y", withDetails: consumption).responseData(completionHandler: { response in
            let alertController = UIAlertController(
                title: NSLocalizedString("Success", comment: "Title"),
                message: NSLocalizedString("Voedsel is toegevoegd", comment: "Message"),
                preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Ok"), style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        })
    }
    
    func createNewPatient(id: Int) -> PatientConsumption {
        let consumptionPatient : PatientConsumption = PatientConsumption(id: id)
        return consumptionPatient
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

    
}


