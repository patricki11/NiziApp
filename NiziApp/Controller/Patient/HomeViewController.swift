//
//  HomeViewController.swift
//  NiziApp
//
//  Created by Samir Yeasin on 13/12/2020.
//  Copyright © 2020 Samir Yeasin. All rights reserved.
//

import Foundation
import UIKit
import SwiftKeychainWrapper


class HomeViewController: UIViewController {
    
    var doctorId : Int!
    weak var patient : NewPatient!
    
    var patientGuidelines : [NewDietaryManagement] = []
    var patientConsumption : [NewConsumption] = []
    var currentDayCounter : Int = 0
   
    var selectedDate : Date?
    
    @IBOutlet weak var guidelineTableView: UITableView!
    @IBOutlet weak var dayOverviewLabel: UILabel!
    @IBOutlet weak var currentWeekLabel: UILabel!
    
    @IBAction func getPreviousWeek(_ sender: Any) {
        currentDayCounter -= 1
        changeCurrentDayLabel()
        getConsumptions()
    }
    
    @IBAction func getNextWeek(_ sender: Any) {
        currentDayCounter += 1
        changeCurrentDayLabel()
        getConsumptions()
    }
    
    lazy var apiDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        return formatter
    }()
    
    lazy var readableDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM YYYY"
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        print(KeychainWrapper.standard.string(forKey: "patientId")!)
        self.navigationController?.navigationBar.isTranslucent = true
        title = NSLocalizedString("Overview", comment: "")
        setupTableView()
        changeCurrentDayLabel()
        getDietaryGuidelines()
        getConsumptions()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        getDietaryGuidelines()
        getConsumptions()
    }

    
    func updateGuidelines() {
        guidelineTableView?.reloadData()
    }
    
    func changeCurrentDayLabel() {

        selectedDate = Calendar.current.date(byAdding: .day, value: currentDayCounter, to: Date())
                
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-YYYY"
        
        if(currentDayCounter == -1) {
            currentWeekLabel.text = NSLocalizedString("Yesterday", comment: "")
        }
        else if(currentDayCounter == 0) {
            currentWeekLabel.text = NSLocalizedString("Today", comment: "")
        }
        else if(currentDayCounter == 1) {
            currentWeekLabel.text = NSLocalizedString("Tomorrow", comment: "")
        }
        else {
            currentWeekLabel.text = "\(dateFormatter.string(from: selectedDate!))"
        }
        
        updateGuidelines()
    }
    
    func setupTableView() {
        guidelineTableView.delegate = self
        guidelineTableView.dataSource = self
    }
    
    func getDietaryGuidelines() {
        
        let patient = Int(KeychainWrapper.standard.string(forKey: "patientId")!)
        
        NiZiAPIHelper.getDietaryManagement(forDiet: patient!, authenticationCode: KeychainWrapper.standard.string(forKey: "authToken")!).response(completionHandler: {response in
            
            guard let jsonResponse = response.data else { return }

            let jsonDecoder = JSONDecoder()
            
            guard let guidelines = try? jsonDecoder.decode([NewDietaryManagement].self, from: jsonResponse) else { return }
            
            self.patientGuidelines = guidelines
            
            self.guidelineTableView.reloadData()
        })
    }
    
    func getConsumptions() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let patient = Int(KeychainWrapper.standard.string(forKey: "patientId")!)
        
        NiZiAPIHelper.readAllConsumption(withToken: KeychainWrapper.standard.string(forKey: "authToken")!, withPatient: patient!, withStartDate: dateFormatter.string(from: selectedDate!)).response(completionHandler: { response in
            
            guard let jsonResponse = response.data else { return }
            
            let jsonDecoder = JSONDecoder()
            
            guard let consumptions = try? jsonDecoder.decode([NewConsumption].self, from: jsonResponse) else { return }
            
            self.patientConsumption = consumptions
            
            self.guidelineTableView.reloadData()
        })
    }
    
}

extension HomeViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return patientGuidelines.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "PatientGuidelineTableViewCell"
        let cell = guidelineTableView?.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PatientGuidelineTableViewCell

        let filteredList = patientGuidelines
        let guideline = filteredList[indexPath.row]
        var floatTotal : Float = getTotalForCorrespondingCategory(category: (guideline.dietaryRestrictionObject?.plural)!)
        var total : Int = Int(floatTotal)
        
        var progressView = cell.guidelineChartView as! CircularProgressView
        progressView.progressAnimation(minimum: guideline.minimum, maximum: guideline.maximum, currentTotal: total)
        
       
        cell.guidelineNameLabel.text = guideline.dietaryRestrictionObject?.plural
        
        if((guideline.minimum != 0 && guideline.minimum != nil) && (guideline.maximum != 0 && guideline.maximum != nil)) {
            cell.firstGuidelineValueLabel.text = "\( NSLocalizedString("Minimum", comment: "")) \(guideline.minimum!)"
            cell.secondGuidelineValueLabel.text = "\( NSLocalizedString("Maximum", comment: "")) \(guideline.maximum!)"
        }
        else if(guideline.minimum != 0 && guideline.minimum != nil) {
            cell.firstGuidelineValueLabel.text = "\( NSLocalizedString("Minimum", comment: "")) \(guideline.minimum!)"
            cell.secondGuidelineValueLabel.text = ""
        }
        else if(guideline.maximum != 0 && guideline.maximum != nil) {
            cell.firstGuidelineValueLabel.text = "\( NSLocalizedString("Maximum", comment: "")) \(guideline.maximum!)"
            cell.secondGuidelineValueLabel.text = ""
        }
        
        cell.guidelineIconImageView.image = getCorrespondingImageForCategory(category: guideline.dietaryRestrictionObject?.description ?? "")
        
        var min = Double(guideline.minimum ?? 0)
        var max = Double(guideline.maximum ?? 0)
        var total2 = Double(total)
        
        if(total == 0) {
            cell.feedbackLabel.text = "Geen inname"
            cell.feedbackLabel.textColor = UIColor(red: 0xD1, green: 0xBD, blue: 0x76)
            if(total2 < max && min == 0){
                cell.feedbackLabel.text = "Goed bezig"
                cell.feedbackLabel.textColor = UIColor(red: 0x86, green: 0xCD, blue: 0x96)
            }
        }
        
        if(total != 0) {
           
            if(min != 0 && max != 0) {
                if(total2 < max) {
                    cell.feedbackLabel.text = "Blijf zo doorgaan"
                    cell.feedbackLabel.textColor = UIColor(red: 0xD1, green: 0xBD, blue: 0x76)
                }
                else if(total2 >= min && total <= guideline.maximum!) {
                    cell.feedbackLabel.text = "Goed bezig"
                    cell.feedbackLabel.textColor = UIColor(red: 0x86, green: 0xCD, blue: 0x96)
                    
                }
                else if(total2 > max) {
                    cell.feedbackLabel.text = "Beperk uw inname"
                    cell.feedbackLabel.textColor = UIColor(red: 0xCE, green: 0x88, blue: 0x87)
                }
            }
            else if(min != 0) {
                if(total2 >= min) {
                    cell.feedbackLabel.text = "Goed bezig"
                    cell.feedbackLabel.textColor = UIColor(red: 0x86, green: 0xCD, blue: 0x96)
                }
                else if(total2 < min) {
                    cell.feedbackLabel.text = "Blijf zo doorgaan"
                    cell.feedbackLabel.textColor = UIColor(red: 0xD1, green: 0xBD, blue: 0x76)
                }
            }
            else if(max != 0) {
                if(total2 <= max) {
                    cell.feedbackLabel.text = "Blijf zo doorgaan"
                    cell.feedbackLabel.textColor = UIColor(red: 0xD1, green: 0xBD, blue: 0x76)
                }
                else if(total2 > max) {
                    cell.feedbackLabel.text = "Beperk uw inname"
                    cell.feedbackLabel.textColor = UIColor(red: 0xCE, green: 0x88, blue: 0x87)
                }
            }
        }
        
        cell.feedbackLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
        cell.backgroundColor = UIColor(red: 0xFF, green: 0xFF, blue: 0xFF)
        
        return cell
    }
    
    func getTotalForCorrespondingCategory(category: String) -> Float {
        var total : Float = 0
        if(category.contains("Calorie"))
        {
            for consumption in patientConsumption
            {
                total += consumption.foodMealCompenent?.kcal ?? 0
            }
        }
        else if(category.contains("Vocht"))
        {
            for consumption in patientConsumption
            {
                total += consumption.foodMealCompenent?.water ?? 0
            }
        }
        else if(category.contains("Natrium"))
        {
            for consumption in patientConsumption
            {
                total += consumption.foodMealCompenent?.sodium ?? 0
            }
        }
        else if(category.contains("Vezel"))
        {
            for consumption in patientConsumption
            {
                total += consumption.foodMealCompenent?.fiber ?? 0
            }
        }
        else if(category.contains("Eiwit"))
        {
            for consumption in patientConsumption
            {
                total += consumption.foodMealCompenent?.protein ?? 0
            }
        }
        else if(category.contains("Kalium"))
        {
            for consumption in patientConsumption
            {
                total += consumption.foodMealCompenent?.potassium ?? 0
            }
        }
        
        return total
    }
    
    func getCorrespondingImageForCategory(category: String) -> UIImage? {
        
        if(category.contains("Calorie")) {
            return UIImage(named: "Calories_s")!
        }
        else if(category.contains("Vocht"))
        {
            return UIImage(named: "Water_s")!
        }
        else if(category.contains("Natrium")) {
            return UIImage(named: "Salt_s")!
        } else if(category.contains("Vezel")) {
            return UIImage(named: "Grain_s")!
        }
        else if(category.contains("Eiwit")) {
            return UIImage(named: "Protein_s")!
        }
        else if(category.contains("Kalium")) {
            return UIImage(named: "Salt_s")!
        }
        else {
            return nil
        }
    }
    
    func getCorrespondingType(category: String) -> String {
        if(category.contains("Calorie")) {
            return "kcal"
        }
        else if(category.contains("Vocht")) {
            return "gram"
        }
        else if(category.contains("Natrium")) {
            return "gram"
        }
        else if(category.contains("Vezel")) {
            return "gram"
        }
        else if(category.contains("Eiwit")) {
            return "gram"
        }
        else if(category.contains("Kalium")) {
            return "gram"
        }
        else {
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // TODO: Volgende patienten ophalen
    }
    
    
}

extension HomeViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
}

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
