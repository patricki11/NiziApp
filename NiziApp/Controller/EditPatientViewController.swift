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
    
    var patientGuidelines : [DietaryManagement] = []
    var restrictions : [Restrictions] = []
    var restrictionPicker : UIPickerView! = UIPickerView()
    var onlyAllowNumbersDelegate = OnlyAllowNumbersDelegate()

    var activeTextField : UITextField = UITextField()
    
    var patientInfo : PatientPersonalInfo? = nil
    var patientId : Int!
    
    func datePicker() -> UIDatePicker {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.addTarget(self, action: #selector(datePickerChanged(_:)), for: .valueChanged)
        picker.maximumDate = Date()
        return picker
    }
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-YYYY"
        return formatter
    }()
    
    @objc func datePickerChanged(_ sender: UIDatePicker) {
        dateOfBirthField.text = dateFormatter.string(from: sender.date)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Bewerken Patiënt"
        dateOfBirthField.inputView = datePicker()
        getPatientObject()
        createRestrictionPicker()
        restrictions = getRestrictions()
        setLanguageSpecificText()
        getPatientGuidelines()
        setNumbersOnlyDelegate()
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
            switch guideline.description {
            case "Calorieverrijking":
                setGuidelineFields(guideline: guideline, field: caloriesMinimumField)
                break
            case "Caloriebeperking":
                setGuidelineFields(guideline: guideline, field: caloriesMaximumField)
                break
            case "Vochtverrijking":
                setGuidelineFields(guideline: guideline, field: waterMinimumField)
                break
            case "Vochtbeperking":
                setGuidelineFields(guideline: guideline, field: waterMaximumField)
                break
            case "Natriumverrijking":
                setGuidelineFields(guideline: guideline, field: sodiumMinimumField)
                break
            case "Natriumbeperking":
                setGuidelineFields(guideline: guideline, field: sodiumMaximumField)
                break
            case "Kaliumverrijking":
                setGuidelineFields(guideline: guideline, field: potassiumMinimumField)
                break
            case "Kaliumbeperking":
                setGuidelineFields(guideline: guideline, field: potassiumMaximumField)
                break
            case "Eiwitverrijking":
                setGuidelineFields(guideline: guideline, field: proteinMinimumFIeld)
                break
            case "Eiwitbeperking":
                setGuidelineFields(guideline: guideline, field: proteinMaximumField)
                break
            case "Vezelverrijking":
                setGuidelineFields(guideline: guideline, field: grainMinimumField)
                break
            case "Vezelbeperking":
                setGuidelineFields(guideline: guideline, field: grainMaximumField)
                break
            default:
                break
            }
        }
    }
    
    func setGuidelineFields(guideline: DietaryManagement, field: UITextField) {
        field.text = String(guideline.amount)
    }
    
    func fillFieldsWithPatientInfo() {
        firstNameField.text = patientInfo?.firstName
        surnameField.text = patientInfo?.lastName
        
        let dateFormatterFrom = DateFormatter()
        dateFormatterFrom.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let dateFormatterTo = DateFormatter()
        dateFormatterTo.dateFormat = "dd-MM-YYYY"
        
        let date : Date = dateFormatterFrom.date(from: patientInfo?.dateOfBirth ?? "") ?? Date()
        
        dateOfBirthField.text = dateFormatterTo.string(from: date)
    }
    
    func setLanguageSpecificText() {
        firstNameLabel.text = NSLocalizedString("firstName", comment: "")
        surnameLabel.text = NSLocalizedString("surname", comment: "")
        dateOfBirthLabel.text = NSLocalizedString("dateOfBirth", comment: "")
        personalInfoLabel.text = NSLocalizedString("personalInfo", comment: "")
        editPatientButton.setTitle(NSLocalizedString("editPatient", comment: ""), for: .normal)
        
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
        
        // TODO: Localizable Strings
        guidelineInfoLabel.text = "Richtlijnen"
    }
    
    @IBAction func confirmEdit(_ sender: Any) {
        if(allRequiredFieldsFilled()) {
            // TODO: Patientgegevens bewerken call van API
        }
        else {
            // TODO: Message - Not all fields filled
        }
    }
    
    
    func createRestrictionPicker() {
        restrictionPicker.dataSource = self
        restrictionPicker.delegate = self
    }
    
    func getPatientGuidelines() {
        NiZiAPIHelper.getDietaryManagement(forDiet: patientId, authenticationCode: KeychainWrapper.standard.string(forKey: "authToken")!).response(completionHandler: {response in
            
            guard let jsonResponse = response.data else { return }

            let jsonDecoder = JSONDecoder()
            
            guard let guidelines = try? jsonDecoder.decode(PatientDietaryGuidelines.self, from: jsonResponse) else { return }
            
            self.patientGuidelines = guidelines.dietaryManagements
            self.setPatientGuidelines()
        })
    }
    
    func getRestrictions() -> [Restrictions]{
        return [
            Restrictions(id: 0, description: "Kies een Richtlijn"),
            Restrictions(id: 1, description: "Caloriebeperking"),
            Restrictions(id: 2, description: "Calotieverrijking"),
            Restrictions(id: 3, description: "Eiwitbeperking"),
            Restrictions(id: 4, description: "Eiwitbverrijking"),
            Restrictions(id: 5, description: "Kaliumbeperking"),
            Restrictions(id: 6, description: "Natriumbeperkng"),
            Restrictions(id: 7, description: "Vezelverrijking"),
            Restrictions(id: 8, description: "Vochtbeperking")
        ]
    }
    
    func getPatientObject() {
        NiZiAPIHelper.getPatient(byId: patientId, authenticationCode: KeychainWrapper.standard.string(forKey: "authToken")!).response(completionHandler: { response in
            guard let jsonResponse = response.data else { return }
            let jsonDecoder = JSONDecoder()
            
            guard let personalInfo = try? jsonDecoder.decode(PatientPersonalInfo.self, from: jsonResponse) else { return }
            
            self.patientInfo = personalInfo
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
        patientInfo?.firstName = ""
        patientInfo?.lastName = ""
    }
}
extension EditPatientViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return restrictions.count
    }
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return restrictions[row].description
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        activeTextField.text = (row != 0) ? restrictions[row].description : ""
    }
}
extension EditPatientViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
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
