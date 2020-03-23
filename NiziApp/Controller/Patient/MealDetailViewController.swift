//
//  MealDetailViewController.swift
//  NiziApp
//
//  Created by Wing lam on 03/01/2020.
//  Copyright © 2020 Samir Yeasin. All rights reserved.
//


import UIKit
import SwiftKeychainWrapper
import Kingfisher

class MealDetailViewController: UIViewController {
    
    @IBOutlet weak var MealTitle: UILabel!
    @IBOutlet weak var MealPicture: UIImageView!
    @IBOutlet weak var MealPortion: UILabel!
    @IBOutlet weak var AmountPortion: UILabel!
    @IBOutlet weak var AmountField: UITextField!
    @IBOutlet weak var ConsumptionTitle: UILabel!
    @IBOutlet weak var CalorieText: UILabel!
    @IBOutlet weak var FiberText: UILabel!
    @IBOutlet weak var ProteinText: UILabel!
    @IBOutlet weak var WaterText: UILabel!
    @IBOutlet weak var SodiumText: UILabel!
    @IBOutlet weak var KaliumText: UILabel!
    
    var mealItem: Meal?
    let patientIntID : Int? = Int(KeychainWrapper.standard.string(forKey: "patientId")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetupData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          // Hide the Navigation Bar
          self.navigationController?.setNavigationBarHidden(false, animated: animated)
      }
    
    @IBAction func AddMealtoDiary(_ sender: Any) {
        addConsumption()
    }
    
    func SetupData()
    {
        MealTitle.text = mealItem?.name
        
        let url = URL(string: mealItem!.picture)
        MealPicture.kf.setImage(with: url)
        
        let calorieString : String = String(format:"%.1f",mealItem!.kCal)
        CalorieText.text = calorieString
        
        let proteinString : String = String(format:"%.1f",mealItem!.protein)
        ProteinText.text = proteinString
        
        let fiberString : String = String(format:"%.1f",mealItem!.fiber)
        FiberText.text = fiberString
        
        let calciumString : String = String(format:"%.1f",mealItem!.calcium)
        KaliumText.text = calciumString
        
        let sodiumString : String = String(format:"%.1f",mealItem!.sodium)
        SodiumText.text = sodiumString
        
    }
    func addConsumption() {
        let date = KeychainWrapper.standard.string(forKey: "date")!
        let newdate = date + "T00:00:00"
        
        let consumption = self.createNewConsumptionObject(foodName: mealItem!.name, kCal: mealItem!.kCal, protein: mealItem!.protein, fiber: mealItem!.fiber, calium: mealItem!.calcium, sodium: mealItem!.sodium, amount: 1, weigthUnitId: 1.0, date: newdate, patientid: patientIntID!, foodId: mealItem!.mealId, water: 0.0)
        NiZiAPIHelper.addConsumption(withDetails: consumption, authenticationCode: KeychainWrapper.standard.string(forKey: "authToken")!).responseData(completionHandler: { response in
            // TODO: Melden aan patient dat de voedsel is toegevoegd.
        })
    }
    
    func createNewConsumptionObject(foodName: String, kCal: Double, protein: Double, fiber: Double, calium: Double, sodium: Double, amount: Int, weigthUnitId: Double, date: String, patientid: Int, foodId: Int, water: Double ) -> Consumption {
        
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
            water: water
        )
        return consumption
    }
    
    
}
