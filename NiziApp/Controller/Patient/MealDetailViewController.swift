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
    
    
    @IBOutlet weak var MealTimeSegment: UISegmentedControl!
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
    
    var mealtimeString : String = ""
    var mealItem: NewMeal?
    
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
        MealTitle.text = mealItem?.foodMealComponent.name
        
        let url = URL(string: mealItem!.foodMealComponent.imageUrl)
        MealPicture.kf.setImage(with: url)
        
        let calorieString : String = String(format:"%.1f",mealItem!.foodMealComponent.kcal)
        CalorieText.text = calorieString
        
        let proteinString : String = String(format:"%.1f",mealItem!.foodMealComponent.protein)
        ProteinText.text = proteinString
        
        let fiberString : String = String(format:"%.1f",mealItem!.foodMealComponent.fiber)
        FiberText.text = fiberString
        
        let calciumString : String = String(format:"%.1f",mealItem!.foodMealComponent.potassium)
        KaliumText.text = calciumString
        
        let sodiumString : String = String(format:"%.1f",mealItem!.foodMealComponent.sodium)
        SodiumText.text = sodiumString
        
        let waterString : String = String(format:"%.1f",mealItem!.foodMealComponent.water)
        WaterText.text = waterString
        
    }
    func addConsumption() {
        let date = KeychainWrapper.standard.string(forKey: "date")!
        let newdate = date + "T00:00:00"
        
        switch MealTimeSegment.selectedSegmentIndex {
               case 0:
                   mealtimeString = "Ontbijt"
                   break
               case 1:
                   mealtimeString = "Lunch"
                   break
               case 2:
                   mealtimeString = "AvondEten"
                   break
               case 3:
                   mealtimeString = "Snack"
               default:
                   break
               }
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
            mealTime:mealTime
        )
        return consumption
    }
    
    
}
