//
//  PatientOverviewViewController.swift
//  NiziApp
//
//  Created by Samir Yeasin on 02/01/2020.
//  Copyright © 2020 Samir Yeasin. All rights reserved.
//

import Foundation
import UIKit
import SwiftKeychainWrapper

class PatientOverviewViewController : UIViewController
{
    var doctorId : Int!
    weak var patient : NewPatient!
    @IBOutlet weak var ageGenderLabel: UILabel!
    
    @IBOutlet weak var patientNameLabel: UILabel!
    
    @IBOutlet weak var dayOverviewLabel: UILabel!
    @IBOutlet weak var guidelineTableView: UITableView!
    
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
    
    var patientGuidelines : [NewDietaryManagement] = []
    var patientConsumption : [NewConsumption] = []
    var currentDayCounter : Int = 0
   
    var selectedDate : Date?
    
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
    
    func changeAgeGenderLabel() {
        let gender = patient.gender
        let birthdate = apiDateFormatter.date(from: patient.dateOfBirth)
        let readableDateOfBirth = readableDateFormatter.string(from: birthdate!)
        
        let ageComponents = Calendar.current.dateComponents([.year], from: birthdate!, to: Date())
        let age = ageComponents.year!
        
        ageGenderLabel.text = "\(gender) - \(readableDateOfBirth) (\(age))"
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
    
    func updateGuidelines() {
        guidelineTableView?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = true
        title = NSLocalizedString("Overview", comment: "")
        setupTableView()
        setLanguageSpecificText()
        changeCurrentDayLabel()
        getDietaryGuidelines()
        changeAgeGenderLabel()
        getConsumptions()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        getDietaryGuidelines()
        changeAgeGenderLabel()
        getConsumptions()
    }
    
    func setLanguageSpecificText() {
        patientNameLabel.text = "\(patient.userObject!.first_name) \(patient.userObject!.last_name)"
    }
    
    func setupTableView() {
        guidelineTableView.delegate = self
        guidelineTableView.dataSource = self
    }
    
    @IBAction func editPatient(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let patientDetailVC = storyboard.instantiateViewController(withIdentifier: "EditPatientViewController") as! EditPatientViewController
        patientDetailVC.patientId = patient.id
        self.navigationController?.pushViewController(patientDetailVC, animated: true)
    }
    
    @IBAction func navigateToConversations(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let conversationVC = storyboard.instantiateViewController(withIdentifier: "AddConversationViewController") as! AddConversationViewController
        conversationVC.patientId = patient.id
        conversationVC.doctorId = doctorId
        self.navigationController?.pushViewController(conversationVC, animated: true)
    }
    
    @IBAction func navigateToDiary(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let diaryVC = storyboard.instantiateViewController(withIdentifier: "ShowPatientDiaryViewController") as! ShowPatientDiaryViewController
        diaryVC.patient = patient
        self.navigationController?.pushViewController(diaryVC, animated: true)
    }
    
    func getDietaryGuidelines() {
        NiZiAPIHelper.getDietaryManagement(forDiet: patient.id!, authenticationCode: KeychainWrapper.standard.string(forKey: "authToken")!).response(completionHandler: {response in
            
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
        
        NiZiAPIHelper.readAllConsumption(withToken: KeychainWrapper.standard.string(forKey: "authToken")!, withPatient: patient.id!, withStartDate: dateFormatter.string(from: selectedDate!)).response(completionHandler: { response in
            
            guard let jsonResponse = response.data else { return }
            
            let jsonDecoder = JSONDecoder()
            
            guard let consumptions = try? jsonDecoder.decode([NewConsumption].self, from: jsonResponse) else { return }
            
            self.patientConsumption = consumptions
            
            self.guidelineTableView.reloadData()
        })
    }
}

extension PatientOverviewViewController : UITableViewDataSource {
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

extension PatientOverviewViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
}
