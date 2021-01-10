//
//  EditPatientViewController.swift
//  NiziApp
//
//  Created by Samir Yeasin on 05/01/2020.
//  Copyright © 2020 Samir Yeasin. All rights reserved.
//

import Foundation
import UIKit
import SwiftKeychainWrapper

class EditPatientViewController : UIViewController {
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var surnameLabel: UILabel!
    @IBOutlet weak var dateOfBirthLabel: UILabel!
    
    @IBOutlet weak var personalInfoLabel: UILabel!
    @IBOutlet weak var guidelineInfoLabel: UILabel!
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var surnameField: UITextField!
    @IBOutlet weak var dateOfBirthField: UITextField!
    var newDateOfBirth : String? = ""
    
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var genderManButton: UIButton!
    @IBOutlet weak var genderWomanButton: UIButton!
    @IBOutlet weak var genderManLabel: UILabel!
    @IBOutlet weak var genderWomanLabel: UILabel!
    
    @IBOutlet weak var caloriesTitle: UILabel!
    @IBOutlet weak var caloriesMinimumTitle: UILabel!
    @IBOutlet var caloriesMinimumField: UITextField!
    @IBOutlet weak var caloriesMaximumTitle: UILabel!
    @IBOutlet var caloriesMaximumField: UITextField!
    
    @IBOutlet weak var waterTitle: UILabel!
    @IBOutlet weak var waterMinimumTitle: UILabel!
    @IBOutlet weak var waterMinimumField: UITextField!
    @IBOutlet weak var waterMaximumTitle: UILabel!
    @IBOutlet weak var waterMaximumField: UITextField!
    
    @IBOutlet weak var sodiumTitle: UILabel!
    @IBOutlet weak var sodiumMinimumTitle: UILabel!
    @IBOutlet weak var sodiumMinimumField: UITextField!
    @IBOutlet weak var sodiumMaximumTitle: UILabel!
    @IBOutlet weak var sodiumMaximumField: UITextField!
    
    @IBOutlet weak var potassiumTitle: UILabel!
    @IBOutlet weak var potassiumMinimumTitle: UILabel!
    @IBOutlet weak var potassiumMinimumField: UITextField!
    @IBOutlet weak var potassiumMaximumTitle: UILabel!
    @IBOutlet weak var potassiumMaximumField: UITextField!
    
    @IBOutlet weak var proteinTitle: UILabel!
    @IBOutlet weak var proteinMinimumTitle: UILabel!
    @IBOutlet weak var proteinMinimumFIeld: UITextField!
    @IBOutlet weak var proteinMaximumTitle: UILabel!
    @IBOutlet weak var proteinMaximumField: UITextField!
    
    @IBOutlet weak var grainTitle: UILabel!
    @IBOutlet weak var grainMinimumTitle: UILabel!
    @IBOutlet weak var grainMinimumField: UITextField!
    @IBOutlet weak var grainMaximumTitle: UILabel!
    @IBOutlet weak var grainMaximumField: UITextField!
    
    @IBOutlet weak var editPatientButton: UIButton!
    
    var patientGuidelines : [NewDietaryManagement] = []
    var newGuidelines : [NewDietaryManagement] = []
    
    var completedDeleting : [NewDietaryManagement] = []
    var completedUpdating : [NewDietaryManagement] = []
    
    var onlyAllowNumbersDelegate = OnlyAllowNumbersDelegate()

    var activeTextField : UITextField = UITextField()
    
    var patient : NewPatient? = nil
    var user : NewUser? = nil
    
    var patientId : Int!
    
    func datePicker() -> UIDatePicker {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.addTarget(self, action: #selector(datePickerChanged(_:)), for: .valueChanged)
        picker.maximumDate = Date()
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .wheels
        }
        return picker
    }
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-YYYY"
        return formatter
    }()
    
    lazy var apiDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        return formatter
    }()
    
    @objc func datePickerChanged(_ sender: UIDatePicker) {
        patient?.dateOfBirth = apiDateFormatter.string(from: sender.date)
        dateOfBirthField.text = dateFormatter.string(from: sender.date)
    }
    
    @IBAction func genderManSelected(_ sender: Any) {
        patient?.gender = "Man"
        genderManButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        genderWomanButton.setImage(UIImage(systemName: "circle"), for: .normal)
    }
    
    @IBAction func genderWomanSelected(_ sender: Any) {
        patient?.gender = "Vrouw"
        genderManButton.setImage(UIImage(systemName: "circle"), for: .normal)
        genderWomanButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("EditPatient", comment: "")
        dateOfBirthField.inputView = datePicker()
        getPatientObject()
        setLanguageSpecificText()
        getPatientGuidelines()
        setNumbersOnlyDelegate()
        removeKeyboardAfterClickingOutsideField()
    }
    
    func setNumbersOnlyDelegate() {
        caloriesMinimumField.delegate = onlyAllowNumbersDelegate
        caloriesMaximumField.delegate = onlyAllowNumbersDelegate
        waterMinimumField.delegate = onlyAllowNumbersDelegate
        waterMaximumField.delegate = onlyAllowNumbersDelegate
        sodiumMinimumField.delegate = onlyAllowNumbersDelegate
        sodiumMaximumField.delegate = onlyAllowNumbersDelegate
        potassiumMinimumField.delegate = onlyAllowNumbersDelegate
        potassiumMaximumField.delegate = onlyAllowNumbersDelegate
        proteinMinimumFIeld.delegate = onlyAllowNumbersDelegate
        proteinMaximumField.delegate = onlyAllowNumbersDelegate
        grainMinimumField.delegate = onlyAllowNumbersDelegate
        grainMaximumField.delegate = onlyAllowNumbersDelegate
    }
    
    func setPatientGuidelines() {
        for guideline in patientGuidelines {
            switch guideline.dietaryRestrictionObject?.plural {
            case "Calorieën":
                setGuidelineFields(guideline: guideline, minimumField: caloriesMinimumField, maximumField: caloriesMaximumField)
                break
            case "Vocht":
                setGuidelineFields(guideline: guideline, minimumField: waterMinimumField, maximumField: waterMaximumField)
                break
            case "Natrium":
                setGuidelineFields(guideline: guideline, minimumField: sodiumMinimumField, maximumField: sodiumMaximumField)
                break
            case "Kalium":
                setGuidelineFields(guideline: guideline, minimumField: potassiumMinimumField, maximumField: potassiumMaximumField)
                break
            case "Eiwitten":
                setGuidelineFields(guideline: guideline, minimumField: proteinMinimumFIeld, maximumField: proteinMaximumField)
                break
            case "Vezels":
                setGuidelineFields(guideline: guideline, minimumField: grainMinimumField, maximumField: grainMaximumField)
                break
            default:
                break
            }
        }
    }
    
    func setGuidelineFields(guideline: NewDietaryManagement, minimumField: UITextField, maximumField: UITextField) {
        if(guideline.minimum != nil) {
            minimumField.text = String(format: "%d", guideline.minimum ?? "")
        }
        if(guideline.maximum != nil) {
            maximumField.text = String(format: "%d", guideline.maximum ?? "")
        }
    }
    
    func fillFieldsWithPatientInfo() {
        firstNameField.text = patient?.userObject?.first_name
        surnameField.text = patient?.userObject?.last_name
        
        let date : Date = apiDateFormatter.date(from: patient?.dateOfBirth ?? "") ?? Date()
        
        dateOfBirthField.text = dateFormatter.string(from: date)
        
        let gender = patient?.gender ?? ""
        if(gender == "Man") {
            genderManButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        }
        else if(gender == "Vrouw") {
            genderWomanButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        }
    }
    
    func setLanguageSpecificText() {
        firstNameLabel.text = NSLocalizedString("firstName", comment: "")
        surnameLabel.text = NSLocalizedString("surname", comment: "")
        dateOfBirthLabel.text = NSLocalizedString("dateOfBirth", comment: "")
        personalInfoLabel.text = NSLocalizedString("personalInfo", comment: "")
        editPatientButton.setTitle(NSLocalizedString("edit", comment: ""), for: .normal)
        
        caloriesTitle.text = NSLocalizedString("caloriesTitle", comment: "")
        waterTitle.text = NSLocalizedString("waterTitle", comment: "")
        sodiumTitle.text = NSLocalizedString("sodiumTitle", comment: "")
        potassiumTitle.text = NSLocalizedString("potassiumTitle", comment: "")
        proteinTitle.text = NSLocalizedString("proteinTitle", comment: "")
        grainTitle.text = NSLocalizedString("grainTitle", comment: "")
        
        caloriesMinimumTitle.text = NSLocalizedString("Minimum", comment: "")
        waterMinimumTitle.text = NSLocalizedString("Minimum", comment: "")
        sodiumMinimumTitle.text = NSLocalizedString("Minimum", comment: "")
        potassiumMinimumTitle.text = NSLocalizedString("Minimum", comment: "")
        proteinMinimumTitle.text = NSLocalizedString("Minimum", comment: "")
        grainMinimumTitle.text = NSLocalizedString("Minimum", comment: "")
        
        caloriesMaximumTitle.text = NSLocalizedString("Maximum", comment: "")
        waterMaximumTitle.text = NSLocalizedString("Maximum", comment: "")
        sodiumMaximumTitle.text = NSLocalizedString("Maximum", comment: "")
        potassiumMaximumTitle.text = NSLocalizedString("Maximum", comment: "")
        proteinMaximumTitle.text = NSLocalizedString("Maximum", comment: "")
        grainMaximumTitle.text = NSLocalizedString("Maximum", comment: "")

        guidelineInfoLabel.text = NSLocalizedString("guidelines", comment: "")
        genderLabel.text = NSLocalizedString("Gender", comment: "")
        genderManLabel.text = NSLocalizedString("Man", comment: "")
        genderWomanLabel.text = NSLocalizedString("Woman", comment: "")
    }
    
    
    @IBAction func confirmEdit(_ sender: Any) {
        if(allRequiredFieldsFilled()) {
            updatePatientData()
            updateGuidelines()
        }
        else {
            showRequiredFieldsNotFilledMessage()
        }
    }
    
    func updatePatientData() {
        NiZiAPIHelper.updatePatientData(byId: patient!.id!, withDetails: patient!, authenticationCode: KeychainWrapper.standard.string(forKey: "authToken")!).responseData(completionHandler: { _ in })
        
        user?.first_name = firstNameField.text!
        user?.last_name = surnameField.text!
        NiZiAPIHelper.updatePatientUserData(byId: user!.id!, withDetails: user!, authenticationCode: KeychainWrapper.standard.string(forKey: "authToken")!).responseData(completionHandler: { _ in })
    }
    
    func updateGuidelines() {
        getNewGuidelines()
        deactivateOldGuidelines()
        createNewGuidelines()
    }
    
    func deactivateOldGuidelines() {
        for guideline in patientGuidelines {
            guideline.is_active = false
            NiZiAPIHelper.updateDieteryManagement(forDiet: guideline.id!, withGuideline: guideline, authenticationCode: KeychainWrapper.standard.string(forKey: "authToken")!).responseData(completionHandler: { response in
                self.completedDeleting.append(guideline)
                
                if(self.completedAllRequests()) {
                    self.showUpdatedMessage()
                }
            })
        }
    }
    
    func createNewGuidelines() {
        for guideline in newGuidelines {
            NiZiAPIHelper.createDietaryManagement(forPatient: patientId, withGuideline: guideline, authenticationCode: KeychainWrapper.standard.string(forKey: "authToken")!).responseJSON(completionHandler: { response in

                self.completedUpdating.append(guideline)
                
                if(self.completedAllRequests()) {
                    self.showUpdatedMessage()
                }
            })
        }
    }
    
    func completedAllRequests() -> Bool {
        if(completedUpdating.count == self.newGuidelines.count && completedDeleting.count == self.patientGuidelines.count) {
            return true
        }
        else {
            return false
        }
    }
    
    func getPatientGuidelines() {
        NiZiAPIHelper.getDietaryManagement(forDiet: patientId, authenticationCode: KeychainWrapper.standard.string(forKey: "authToken")!).response(completionHandler: {response in
            
            guard let jsonResponse = response.data else { return }

            let jsonDecoder = JSONDecoder()
            
            guard let guidelines = try? jsonDecoder.decode([NewDietaryManagement].self, from: jsonResponse) else { return }
            
            self.patientGuidelines = guidelines
            self.setPatientGuidelines()
        })
    }
    
    func getNewGuidelines() {
        addCaloriesGuideline()
        addWaterGuideline()
        addSodiumGuideline()
        addPotassiumGuideline()
        addProteinGuideline()
        addfiberGuideline()
    }
    
    func addCaloriesGuideline() {
        var minimum : Int? = nil
        var maximum : Int? = nil
        
        if(caloriesMinimumField.text != nil) {
            minimum = Int(caloriesMinimumField.text!)
        }
        if(caloriesMaximumField.text != nil) {
            maximum = Int(caloriesMaximumField.text!)
        }
        
        if(minimum == nil && maximum == nil) {
            return
        }

        newGuidelines.append(
            NewDietaryManagement(
                id: 0,
                isActive: true,
                dietaryRestriction: 1,
                patient: patientId,
                createdAt: nil,
                updatedAt: nil,
                minimum: minimum,
                maximum: maximum
            )
        )
    }
    
    func addWaterGuideline() {
        var minimum : Int? = nil
        var maximum : Int? = nil
        
        if(waterMinimumField.text != nil) {
            minimum = Int(waterMinimumField.text!)
        }
        if(waterMaximumField.text != nil) {
            maximum = Int(waterMaximumField.text!)
        }

        if(minimum == nil && maximum == nil) {
            return
        }
        
        newGuidelines.append(
            NewDietaryManagement(
                id: 0,
                isActive: true,
                dietaryRestriction: 2,
                patient: patientId,
                createdAt: nil,
                updatedAt: nil,
                minimum: minimum,
                maximum: maximum
            )
        )
    }
    
    func addSodiumGuideline() {
        var minimum : Int? = nil
        var maximum : Int? = nil
        
        if(sodiumMinimumField.text != nil) {
            minimum = Int(sodiumMinimumField.text!)
        }
        if(sodiumMaximumField.text != nil) {
            maximum = Int(sodiumMaximumField.text!)
        }
        
        if(minimum == nil && maximum == nil) {
            return
        }

        newGuidelines.append(
            NewDietaryManagement(
                id: 0,
                isActive: true,
                dietaryRestriction: 3,
                patient: patientId,
                createdAt: nil,
                updatedAt: nil,
                minimum: minimum,
                maximum: maximum
            )
        )
    }
    
    func addPotassiumGuideline() {
        var minimum : Int? = nil
        var maximum : Int? = nil
        
        if(potassiumMinimumField.text != nil) {
            minimum = Int(potassiumMinimumField.text!)
        }
        if(potassiumMaximumField.text != nil) {
            maximum = Int(potassiumMaximumField.text!)
        }

        if(minimum == nil && maximum == nil) {
            return
        }
        
        newGuidelines.append(
            NewDietaryManagement(
                id: 0,
                isActive: true,
                dietaryRestriction: 4,
                patient: patientId,
                createdAt: nil,
                updatedAt: nil,
                minimum: minimum,
                maximum: maximum
            )
        )
    }
    
    func addProteinGuideline() {
        var minimum : Int? = nil
        var maximum : Int? = nil
        
        if(proteinMinimumFIeld.text != nil) {
            minimum = Int(proteinMinimumFIeld.text!)
        }
        if(proteinMaximumField.text != nil) {
            maximum = Int(proteinMaximumField.text!)
        }
        
        if(minimum == nil && maximum == nil) {
            return
        }

        newGuidelines.append(
            NewDietaryManagement(
                id: 0,
                isActive: true,
                dietaryRestriction: 5,
                patient: patientId,
                createdAt: nil,
                updatedAt: nil,
                minimum: minimum,
                maximum: maximum
            )
        )
    }
    
    func addfiberGuideline() {
        var minimum : Int? = nil
        var maximum : Int? = nil
        
        if(grainMinimumField.text != nil) {
            minimum = Int(grainMinimumField.text!)
        }
        if(grainMaximumField.text != nil) {
            maximum = Int(grainMaximumField.text!)
        }
        
        if(minimum == nil && maximum == nil) {
            return
        }

        newGuidelines.append(
            NewDietaryManagement(
                id: 0,
                isActive: true,
                dietaryRestriction: 6,
                patient: patientId,
                createdAt: nil,
                updatedAt: nil,
                minimum: minimum,
                maximum: maximum
            )
        )
    }
    
    func getPatientObject() {
        NiZiAPIHelper.getPatient(byId: patientId, authenticationCode: KeychainWrapper.standard.string(forKey: "authToken")!).response(completionHandler: { response in
            guard let jsonResponse = response.data else { return }
            let jsonDecoder = JSONDecoder()
            
            guard let patient = try? jsonDecoder.decode(NewPatient.self, from: jsonResponse) else { return }
            
            self.patient = patient
            self.user = patient.userObject
            self.fillFieldsWithPatientInfo()
            
        })
    }
    
    func allRequiredFieldsFilled() -> Bool {
        let firstName = firstNameField.text
        let surname = surnameField.text
        let dateOfBirth = dateOfBirthField.text
        
        return (firstName != "" && surname != "" && dateOfBirth != "")
    }
    
    func updateNewPatientObject() {
        patient?.userObject?.first_name = ""
        patient?.userObject?.last_name = ""
    }
    
    func showUpdatedMessage() {
        let alertController = UIAlertController(
            title: NSLocalizedString("patientUpdatedTitle", comment: ""),
            message: NSLocalizedString("patientUpdatedMessage", comment: ""),
            preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "Ok"), style: .default, handler: { _ in self.navigateBackToPatientOverview()}))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showRequiredFieldsNotFilledMessage() {
        let alertController = UIAlertController(
            title:NSLocalizedString("requiredFieldsTitle", comment: ""),
            message: NSLocalizedString("requiredFieldsMessage", comment: ""),
            preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "Ok"), style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func navigateBackToPatientOverview() {
        self.navigationController!.popViewController(animated: true)
    }
}

class OnlyAllowNumbersDelegate : UIViewController, UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string.count == 0 {
            return true
        }
        
        if let x = string.rangeOfCharacter(from: NSCharacterSet.decimalDigits) {
          return true
       } else {
          return false
       }
    }
}
