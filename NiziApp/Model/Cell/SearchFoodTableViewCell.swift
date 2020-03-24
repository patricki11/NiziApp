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
    
    let patientIntID : Int? = Int(KeychainWrapper.standard.string(forKey: "patientId")!)
    var foodItem : Food?
    

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
        
        let consumption = self.createNewConsumptionObject(foodName: foodItem!.name, kCal: foodItem!.kCal, protein: foodItem!.protein, fiber: foodItem!.fiber, calium: foodItem!.calcium, sodium: foodItem!.sodium, amount: 1, weigthUnitId: 1.0, date: newdate, patientid: patientIntID!, foodId: foodItem!.foodId, water: foodItem!.water, mealTime: "Ontbijt")
        NiZiAPIHelper.addConsumption(withDetails: consumption, authenticationCode: KeychainWrapper.standard.string(forKey: "authToken")!).responseData(completionHandler: { response in
            // TODO: Melden aan patient dat de voedsel is toegevoegd.
        })
    }
    
    func createNewConsumptionObject(foodName: String, kCal: Double, protein: Double, fiber: Double, calium: Double, sodium: Double, amount: Int, weigthUnitId: Double, date: String, patientid: Int, foodId: Int, water: Double, mealTime: String ) -> Consumption {
        
        let consumption : Consumption = Consumption(
            foodName : foodName,
            kCal: kCal,
            protein: protein,
            fiber: fiber,
            calium: calium,
            sodium: sodium,
            amount: amount,
            weightUnitId: weigthUnitId,
            date: date,
            patientId: patientid,
            id: foodId,
            water: water,
            mealTime: mealTime
        )
        return consumption
    }

}
