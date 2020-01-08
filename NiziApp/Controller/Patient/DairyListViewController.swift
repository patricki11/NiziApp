//
//  DairyListViewController.swift
//  NiziApp
//
//  Created by Samir Yeasin on 29/11/2019.
//  Copyright © 2019 Samir Yeasin. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class DairyListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    let patientIntID : Int? = Int(KeychainWrapper.standard.string(forKey: "patientId")!)
    var consumptions    : [ConsumptionView] = []
    var kcalProgress    : Float = 0.0
    var sodiumProgress  : Float = 0.0
    var proteinProgress : Float = 0.0
    var calciumProgress : Float = 0.0
    var fiberProgress   : Float = 0.0
    var vochtProgress   : Float = 0.0
    
    @IBOutlet weak var DiaryRecentFood: UITableView!
    @IBOutlet weak var DiaryTitleLabel: UILabel!
    @IBOutlet weak var DiaryAddLabel: UILabel!
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
        ProgressCalorie.setProgress(kcalProgress/2500, animated: true)
        ProgressGrain.setProgress(fiberProgress/40, animated: true)
        ProgressHumidity.setProgress(vochtProgress/80, animated: true)
        ProgressProtein.setProgress(proteinProgress/10, animated: true)
        ProgressSodium.setProgress(sodiumProgress/10, animated: true)
        ProgressPotassium.setProgress(calciumProgress/20, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(KeychainWrapper.standard.string(forKey: "patientId"))
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let formattedDate = format.string(from: date)
        //print(formattedDate)
        saveDate(date: formattedDate)
        //print(KeychainWrapper.standard.string(forKey: "date")!)
        setLanguageSpecificText()
        getConsumption(Date: formattedDate)
        SetupDatePicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool){
        getConsumption(Date: KeychainWrapper.standard.string(forKey: "date")!)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        
        // Create date formatter
        let dateFormatter: DateFormatter = DateFormatter()
        
        // Set date format
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // Apply date format
        let selectedDate: String = dateFormatter.string(from: sender.date)
        
        getConsumption(Date: selectedDate)
        saveDate(date: selectedDate)
        //print("Selected value \(selectedDate)")
    }
    
    // API Calls
    func getConsumption(Date date: String) {
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
            self.vochtProgress = Float.random(min: 1.00, max: 80.00)
            self.setProgresss()
            self.DiaryRecentFood?.reloadData()
        })
    }
    
    func Deleteconsumption(Id id: Int){
        NiZiAPIHelper.deleteConsumption(withId: id, authenticationCode: KeychainWrapper.standard.string(forKey: "authToken")!).responseData(completionHandler: { response in
            guard response.data != nil
                else { print("temp1"); return }
        })
        self.setProgresss()
    }
    
    func setLanguageSpecificText() {
        DiaryTitleLabel.text = NSLocalizedString("DiaryTitle", comment: "")
        CalorieLabel.text = NSLocalizedString("Calorie", comment: "")
        GrainLabel.text = NSLocalizedString("Grain", comment: "")
        ProteinLabel.text = NSLocalizedString("Protein", comment: "")
        PotassiumLabel.text = NSLocalizedString("Potassium", comment: "")
        SodiumLabel.text = NSLocalizedString("Natrium", comment: "")
        MoistureLabel.text = NSLocalizedString("Moisture", comment: "")
    }
    
    
    // table functons
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return consumptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let diarycell = tableView.dequeueReusableCell(withIdentifier: "diarycell", for: indexPath) as! DiaryTableViewCell
        let idx: Int = indexPath.row
        diarycell.productTitle?.text = consumptions[idx].foodName
        return diarycell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Deleteconsumption(Id: consumptions[indexPath.row].consumptionId)
            consumptions.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
    
    func saveDate(date: String) {
        KeychainWrapper.standard.set(date, forKey: "date")
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
