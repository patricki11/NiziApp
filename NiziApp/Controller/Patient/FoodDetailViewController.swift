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
    
    let patientIntID : Int? = Int(KeychainWrapper.standard.string(forKey: "patientId")!)
    
    @IBAction func AddToDiary(_ sender: Any) {
        addConsumption()
    }
    var foodItem: Food?
    
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
        
        let url = URL(string: foodItem!.picture)
        Picture.kf.setImage(with: url)
        
        let calorieString : String = String(format:"%.1f",foodItem!.kCal)
        Kcal.text = calorieString
        
        let proteinString : String = String(format:"%.1f",foodItem!.protein)
        Protein.text = proteinString
        
        let fiberString : String = String(format:"%.1f",foodItem!.fiber)
        Fiber.text = fiberString
        
        let calciumString : String = String(format:"%.1f",foodItem!.calcium)
        Calcium.text = calciumString
        
        let sodiumString : String = String(format:"%.1f",foodItem!.sodium)
        Sodium.text = sodiumString
        
        let portionSizeString : String = String(format:"%.1f",foodItem!.portionSize)
        portionSizeLabel.text = portionSizeString
        
        let waterString : String = String(format:"%.1f",foodItem!.water)
        WaterLabel.text = waterString
        
    }
    @IBAction func AddtoFavorites(_ sender: Any) {
        Addfavorite()
        
    }
    
    func Addfavorite() {
        NiZiAPIHelper.addProductToFavorite(forproductId: foodItem!.foodId, forPatient: patientIntID!, authenticationCode: KeychainWrapper.standard.string(forKey: "authToken")!).responseString(completionHandler: {response in
            guard let jsonResponse = response.request
                else { print("Not succeeded"); return }
            print(response.request)
        })
    }
    func addConsumption() {
        let date = KeychainWrapper.standard.string(forKey: "date")!
        let newdate = date + "T00:00:00"
        
        switch MealTime.selectedSegmentIndex {
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
        
        let consumption = self.createNewConsumptionObject(foodName: foodItem!.name, kCal: foodItem!.kCal, protein: foodItem!.protein, fiber: foodItem!.fiber, calium: foodItem!.calcium, sodium: foodItem!.sodium, amount: 1, weigthUnitId: 1.0, date: newdate, patientid: patientIntID!, foodId: foodItem!.foodId, water: foodItem!.water, mealTime: mealtimeString)
        NiZiAPIHelper.addConsumption(withDetails: consumption, authenticationCode: KeychainWrapper.standard.string(forKey: "authToken")!).responseData(completionHandler: { response in
            let alertController = UIAlertController(
                title: NSLocalizedString("Success", comment: "Title"),
                message: NSLocalizedString("Voedsel is toegevoegd", comment: "Message"),
                preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Ok"), style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
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


