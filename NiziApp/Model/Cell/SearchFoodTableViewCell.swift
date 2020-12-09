//
//  SearchFoodTableViewCell.swift
//  NiziApp
//
//  Created by Wing lam on 11/12/2019.
//  Copyright © 2019 Samir Yeasin. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class SearchFoodTableViewCell: UITableViewCell {
    var foodItem : NewFood?
    
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
        let newdate = date + "T00:00:00"
        
        let patient = self.createNewPatient(id: 1)
        
        let weight = self.createNewWeight(id: (self.foodItem?.weightObject!.id)!, unit: (self.foodItem?.weightObject!.unit)!, short: (self.foodItem?.weightObject!.short)!, createdAt: (self.foodItem?.weightObject!.createdAt)!, updatedAt: (self.foodItem?.weightObject!.updatedAt)!)
        
        let consumption = self.createNewConsumptionObject(amount: 1, date: "2020-11-18T00:00:00.000Z", mealTime: "Ontbijt", patient: patient, weightUnit: weight, foodMealComponent: (foodItem?.foodMealComponent)!)
        
        NiZiAPIHelper.addNewConsumption(withToken: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiaWF0IjoxNjA1MTA0Njk3LCJleHAiOjE2MDc2OTY2OTd9.VQqpsXC4IrdPjcNE9cuMpwumiLncAKorGB8eIDAWS2Y", withDetails: consumption).responseData(completionHandler: { response in
            guard let jsonResponse = response.data
                else { print("temp1"); return }
            
            let jsonDecoder = JSONDecoder()
            guard let consumptionlist = try? jsonDecoder.decode( [NewConsumption].self, from: jsonResponse )
                else { print("temp2"); return }
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
