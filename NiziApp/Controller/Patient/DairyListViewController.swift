//
//  DairyListViewController.swift
//  NiziApp
//
//  Created by Samir Yeasin on 29/11/2019.
//  Copyright © 2019 Samir Yeasin. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class DairyListViewController: UIViewController {
    
    
    //let patientIntID : Int? = Int(KeychainWrapper.standard.string(forKey: "patientId")!)
    //var consumptions    : [ConsumptionView] = []
    var kcalProgress    : Float = 0.0
    var sodiumProgress  : Float = 0.0
    var proteinProgress : Float = 0.0
    var calciumProgress : Float = 0.0
    var fiberProgress   : Float = 0.0
    var vochtProgress   : Float = 0.0
    
    
    @IBOutlet weak var ProteinValue: UILabel!
    @IBOutlet weak var NatriumValue: UILabel!
    @IBOutlet weak var Kaliumvalue: UILabel!
    @IBOutlet weak var FiberValue: UILabel!
    @IBOutlet weak var MoistureValue: UILabel!
    @IBOutlet weak var KcalValue: UILabel!
    @IBOutlet weak var CalorieLabel: UILabel!
    @IBOutlet weak var GrainLabel: UILabel!
    @IBOutlet weak var ProteinLabel: UILabel!
    @IBOutlet weak var PotassiumLabel: UILabel!
    @IBOutlet weak var MoistureLabel: UILabel!
    @IBOutlet weak var SodiumLabel: UILabel!
    @IBOutlet weak var ProgressCalorie: UIProgressView!
    @IBOutlet weak var ProgressGrain: UIProgressView!
    @IBOutlet weak var ProgressHumidity: UIProgressView!
    @IBOutlet weak var ProgressProtein: UIProgressView!
    @IBOutlet weak var ProgressSodium: UIProgressView!
    @IBOutlet weak var ProgressPotassium: UIProgressView!
    @IBOutlet weak var DatePicker: UIDatePicker!
    
    fileprivate func SetupDatePicker() {
        DatePicker.setValue(UIColor.white, forKeyPath: "textColor")
        DatePicker.setValue(false, forKeyPath: "highlightsToday")
        DatePicker.backgroundColor = UIColor(red: 0x0A, green: 0x71, blue: 0xCB)
        DatePicker.addTarget(self, action: #selector(DairyListViewController.datePickerValueChanged(_:)), for: .valueChanged)
    }
    
    func setProgresss(){
        ProgressCalorie.setProgress(kcalProgress/2000, animated: true)
        ProgressGrain.setProgress(fiberProgress/40, animated: true)
        ProgressHumidity.setProgress(vochtProgress/4000, animated: true)
        ProgressProtein.setProgress(proteinProgress/48, animated: true)
        ProgressSodium.setProgress(sodiumProgress/1500, animated: true)
        ProgressPotassium.setProgress(calciumProgress/40, animated: true)
        ProteinValue.text = proteinProgress.description
        NatriumValue.text = sodiumProgress.description
        Kaliumvalue.text = calciumProgress.description
        FiberValue.text = fiberProgress.description
        MoistureValue.text = vochtProgress.description
        KcalValue.text = kcalProgress.description
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(KeychainWrapper.standard.string(forKey: "patientId"))
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let formattedDate = format.string(from: date)
        //print(formattedDate)
        saveDate(date: formattedDate)
        //print(KeychainWrapper.standard.string(forKey: "date")!)
      
        //getConsumption(Date: formattedDate)
        SetupDatePicker()
        createLogoutButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool){
        //getConsumption(Date: KeychainWrapper.standard.string(forKey: "date")!)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        
        // Create date formatter
        let dateFormatter: DateFormatter = DateFormatter()
        
        // Set date format
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // Apply date format
        let selectedDate: String = dateFormatter.string(from: sender.date)
        
        //getConsumption(Date: selectedDate)
        saveDate(date: selectedDate)
        //print("Selected value \(selectedDate)")
    }
    
    // API Calls
    /*func getConsumption(Date date: String) {
        NiZiAPIHelper.getAllConsumptions(forPatient: patientIntID!, between: date, and: date, authenticationCode: KeychainWrapper.standard.string(forKey: "authToken")!).responseData(completionHandler: { response in
            
            guard let jsonResponse = response.data
                else { print("temp1"); return }
            
            let jsonDecoder = JSONDecoder()
            guard let consumptionlist = try? jsonDecoder.decode( Diary.self, from: jsonResponse )
                else { print("temp2"); return }
            
            self.consumptions = consumptionlist.consumptions
            self.kcalProgress = consumptionlist.kcalTotal!
            self.proteinProgress = consumptionlist.proteinTotal!
            self.fiberProgress = consumptionlist.fiberTotal!
            self.calciumProgress = consumptionlist.caliumTotal!
            self.sodiumProgress = consumptionlist.sodiumTotal!
            self.vochtProgress = consumptionlist.waterTotal!
            self.setProgresss()
            
        })
    }*/
    
    
    func setLanguageSpecificText() {
        CalorieLabel.text = NSLocalizedString("Calorie", comment: "")
        GrainLabel.text = NSLocalizedString("Grain", comment: "")
        ProteinLabel.text = NSLocalizedString("Protein", comment: "")
        PotassiumLabel.text = NSLocalizedString("Potassium", comment: "")
        SodiumLabel.text = NSLocalizedString("Natrium", comment: "")
        MoistureLabel.text = NSLocalizedString("Moisture", comment: "")
    }
    
    
    func saveDate(date: String) {
        KeychainWrapper.standard.set(date, forKey: "date")
    }
    
    func createLogoutButton() {
        let logoutButton = UIBarButtonItem(title: "Uitloggen", style: .plain, target: self, action: #selector(logout))
        self.navigationItem.leftBarButtonItem = logoutButton
    }
    
    @objc func logout() {
        removeAuthorizationToken()
        navigateToLoginPage()
    }
    
    func removeAuthorizationToken() {
        //KeychainWrapper.standard.removeObject(forKey: "authToken")
        //KeychainWrapper.standard.removeObject(forKey: "patientId")
    }
    
    func navigateToLoginPage() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "ChooseLoginViewController") as! ChooseLoginViewController
        
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    @IBAction func uitloggen(_ sender: Any) {
        //removeAuthorizationToken()
        navigateToLoginPage()
    }
}

// Working with Hex Code
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}


public extension Float {
    
    /// Returns a random floating point number between 0.0 and 1.0, inclusive.
    static var random: Float {
        return Float(arc4random()) / 0xFFFFFFFF
    }
    
    /// Random float between 0 and n-1.
    ///
    /// - Parameter n:  Interval max
    /// - Returns:      Returns a random float point number between 0 and n max
    static func random(min: Float, max: Float) -> Float {
        return Float.random * (max - min) + min
    }
}
