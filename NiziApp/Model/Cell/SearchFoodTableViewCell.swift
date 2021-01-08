//
//  SearchFoodTableViewCell.swift
//  NiziApp
//
//  Created by Samir Yeasin on 11/12/2020.
//  Copyright © 2020 Samir Yeasin. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class SearchFoodTableViewCell: UITableViewCell {
    var foodItem : NewFood?
    var weightUnit : Int = 0
    let patientIntID : Int = Int(KeychainWrapper.standard.string(forKey: "patientId")!)!
    var dialog : PresentDialog?
    
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var foodTitle: UILabel!
    @IBOutlet weak var portionSize: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    @IBAction func QuickAdd(_ sender: Any) {
        self.addConsumption()
    }

    func addConsumption() {
        let date = KeychainWrapper.standard.string(forKey: "date")!
        
        let patient = self.createNewPatient(id: patientIntID)
        
        if(self.foodItem?.weightId == nil){
            self.weightUnit = 8
        }
        else{
            self.weightUnit = (foodItem?.weightId)!
        }
        
        let weight = self.createNewWeight(id: self.weightUnit, unit: "", short: "", createdAt: "", updatedAt: "")
        
        let consumption = self.createNewConsumptionObject(amount: 1, date: date, mealTime: "Ontbijt", patient: patient, weightUnit: weight, foodMealComponent: (foodItem?.foodMealComponent)!)
        
        NiZiAPIHelper.addNewConsumption(withToken: KeychainWrapper.standard.string(forKey: "authToken")!, withDetails: consumption).responseData(completionHandler: { response in
            self.dialog?.addDiary(succeeded: true)
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
}
