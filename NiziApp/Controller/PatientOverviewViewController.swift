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
    weak var patient : NewPatient!
    @IBOutlet weak var averageBetweenLabel: UILabel!
    
    @IBOutlet weak var patientNameLabel: UILabel!
    
    @IBOutlet weak var guidelineSearchField: UITextField!
    @IBOutlet weak var searchGuidelineButton: UIButton!
    
    @IBOutlet weak var weekOverviewLabel: UILabel!
    @IBOutlet weak var guidelineTableView: UITableView!
    
    var patientGuidelines : [DietaryManagement] = []
    var currentWeekCounter : Int = 0
    
    @IBOutlet weak var currentWeekLabel: UILabel!
    
    @IBAction func getPreviousWeek(_ sender: Any) {
        currentWeekCounter -= 1
        changeCurrentWeekLabel()
    }
    
    @IBAction func getNextWeek(_ sender: Any) {
        currentWeekCounter += 1
        changeCurrentWeekLabel()
    }
    
    func changeCurrentWeekLabel() {

        let firstDayOfWeek : Date? = Calendar.current.date(byAdding: .day, value: 7*currentWeekCounter, to: Date().startOfWeek!)
        let lastDayOfWeek : Date? = Calendar.current.date(byAdding: .day, value: 7*currentWeekCounter, to: Date().endOfWeek!)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-YYYY"
        
        averageBetweenLabel.text = "Gemiddelde van \(dateFormatter.string(from: firstDayOfWeek!)) tot \(dateFormatter.string(from: lastDayOfWeek!))"
        
        if(currentWeekCounter == -1) {
            currentWeekLabel.text = "Vorige Week"
        }
        else if(currentWeekCounter == 0) {
            currentWeekLabel.text = "Deze Week"
        }
        else if(currentWeekCounter == 1) {
            currentWeekLabel.text = "Volgende Week"
        }
        else {
            currentWeekLabel.text = "\(dateFormatter.string(from: firstDayOfWeek!)) - \(dateFormatter.string(from: lastDayOfWeek!)) "
        }
        
        updateGuidelines()
    }
    
    func updateGuidelines() {
        guidelineTableView?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = true
        title = "Overzicht"
        setupTableView()
        setLanguageSpecificText()
        changeCurrentWeekLabel()
        getDietaryGuidelines()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        getDietaryGuidelines()
    }
    
    func setLanguageSpecificText() {
        patientNameLabel.text = "\(patient.userObject?.first_name!) \(patient.userObject?.last_name!)"
    }
    
    func setupTableView() {
        guidelineTableView.delegate = self
        guidelineTableView.dataSource = self
    }
    
    @IBAction func editPatient(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let patientDetailVC = storyboard.instantiateViewController(withIdentifier: "EditPatientViewController") as! EditPatientViewController
        patientDetailVC.patientId = patient.id
        print(patient.id)
        self.navigationController?.pushViewController(patientDetailVC, animated: true)
    }
    
    @IBAction func filterGuideline(_ sender: Any) {
        guidelineTableView?.reloadData()
    }
    
    func getFilteredGuidelineList() -> [DietaryManagement] {
        let guidelineName = guidelineSearchField?.text ?? ""
        
        if(guidelineName == "") {
            return patientGuidelines
        }
        else {
            return patientGuidelines.filter { ("\($0.description.lowercased())").contains(guidelineName.lowercased())}
        }
    }
    
    func getDietaryGuidelines() {
        NiZiAPIHelper.getDietaryManagement(forDiet: patient.id!, authenticationCode: KeychainWrapper.standard.string(forKey: "authToken")!).response(completionHandler: {response in
            
            guard let jsonResponse = response.data else { return }

            let jsonDecoder = JSONDecoder()
            
            guard let guidelines = try? jsonDecoder.decode(PatientDietaryGuidelines.self, from: jsonResponse) else { return }
            
            self.patientGuidelines = guidelines.dietaryManagements

            print(self.patientGuidelines.count)
            self.guidelineTableView.reloadData()
        })
    }
}

extension PatientOverviewViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getFilteredGuidelineList().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "PatientGuidelineTableViewCell"
        let cell = guidelineTableView?.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PatientGuidelineTableViewCell

        let filteredList = getFilteredGuidelineList()
        let guideline = filteredList[indexPath.row]
        var average : Int = 0
        
        if(currentWeekCounter <= 0) {
            average = Int.random(in: guideline.amount - 20...guideline.amount + 100)
        }
        cell.averageAmountForWeekLabel.text = "\(average) \(getCorrespondingType(category: guideline.description))"
        cell.guidelineNameLabel.text = guideline.description
        
        var moreOrLess : String = ""
        
        if(guideline.description.contains("beperking")) {
            moreOrLess = "minder dan"
            if(average < guideline.amount) {
                cell.averageAmountForWeekLabel.textColor = UIColor(red: 0, green: 100, blue: 0)
            }
            else {
                cell.averageAmountForWeekLabel.textColor = UIColor(red: 255, green: 0, blue: 0)
            }
        }
        else if(guideline.description.contains("verrijking")) {
            moreOrLess = "meer dan"
            if(average > guideline.amount) {
                cell.averageAmountForWeekLabel.textColor = UIColor(red: 0, green: 100, blue: 0)
            }
            else {
                cell.averageAmountForWeekLabel.textColor = UIColor(red: 255, green: 0, blue: 0)
            }
        }
        
        cell.recommendedAmountLabel.text = "Aanbeveling \(moreOrLess)  \(guideline.amount)"
        
        cell.guidelineIconImageView.image = getCorrespondingImageForCategory(category: guideline.description)
        
        return cell

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

extension Date {
    var startOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 1, to: sunday)
    }

    var endOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 7, to: sunday)
    }
}
