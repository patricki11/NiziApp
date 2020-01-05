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
    weak var patient : Patient!
    @IBOutlet weak var averageBetweenLabel: UILabel!
    
    @IBOutlet weak var patientNameLabel: UILabel!
    
    @IBOutlet weak var guidelineSearchField: UITextField!
    @IBOutlet weak var searchGuidelineButton: UIButton!
    
    @IBOutlet weak var weekOverviewLabel: UILabel!
    @IBOutlet weak var guidelineTableView: UITableView!
    
    var patientGuidelines : [DietaryManagement] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = true
        title = "Overzicht"
        setupTableView()
        setLanguageSpecificText()
        getDietaryGuidelines()
    }
    
    func setLanguageSpecificText() {
        patientNameLabel.text = "\(patient.firstName!) \(patient.lastName!)"
    }
    
    func setupTableView() {
        guidelineTableView.delegate = self
        guidelineTableView.dataSource = self
    }
    
    @IBAction func editPatient(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let patientDetailVC = storyboard.instantiateViewController(withIdentifier: "EditPatientViewController") as! EditPatientViewController
        patientDetailVC.patientId = patient.patientId
        print(patient.patientId)
        self.navigationController?.pushViewController(patientDetailVC, animated: true)
    }
    
    func getDietaryGuidelines() {
        NiZiAPIHelper.getDietaryManagement(forDiet: patient.patientId!, authenticationCode: KeychainWrapper.standard.string(forKey: "authToken")!).response(completionHandler: {response in
            
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
        return patientGuidelines.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "PatientGuidelineTableViewCell"
        let cell = guidelineTableView?.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PatientGuidelineTableViewCell

        let guideline = patientGuidelines[indexPath.row]
        cell.averageAmountForWeekLabel.text = "temp"
        cell.guidelineNameLabel.text = guideline.description
        
        var moreOrLess : String = ""
        
        if(guideline.description.contains("beperking")) {
            moreOrLess = "minder dan"
        }
        else if(guideline.description.contains("verrijking")) {
            moreOrLess = "meer dan"
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // TODO: Volgende patienten ophalen
    }

}

extension PatientOverviewViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
}
