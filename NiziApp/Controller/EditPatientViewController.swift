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
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var confirmPasswordLabel: UILabel!
    
    @IBOutlet weak var personalInfoLabel: UILabel!
    @IBOutlet weak var loginInfoLabel: UILabel!
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var surnameField: UITextField!
    @IBOutlet weak var dateOfBirthField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    @IBOutlet weak var editPatientButton: UIButton!
    
    var restrictions : [Restrictions] = []
    var restrictionPicker : UIPickerView! = UIPickerView()
    var onlyAllowNumbersDelegate = OnlyAllowNumbersDelegate()
    
    @IBOutlet weak var guideline1 : UITextField!
    @IBOutlet weak var guideline2 : UITextField!
    @IBOutlet weak var guideline3 : UITextField!
    @IBOutlet weak var guideline4 : UITextField!
    @IBOutlet weak var guideline5 : UITextField!
    @IBOutlet weak var guideline6 : UITextField!
     
    @IBOutlet weak var amount1 : UITextField!
    @IBOutlet weak var amount2 : UITextField!
    @IBOutlet weak var amount3 : UITextField!
    @IBOutlet weak var amount4 : UITextField!
    @IBOutlet weak var amount5 : UITextField!
    @IBOutlet weak var amount6 : UITextField!
    
    var activeTextField : UITextField = UITextField()
    
    var patientInfo : PatientPersonalInfo? = nil
    var patientId : Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Bewerken Patiënt"
        getPatientObject()
        createRestrictionPicker()
        restrictions = getRestrictions()
        setupGuidelineFields()
        setLanguageSpecificText()
    }
    
    func fillFieldsWithPatientInfo() {
        firstNameField.text = patientInfo?.firstName
        surnameField.text = patientInfo?.lastName
        dateOfBirthField.text = patientInfo?.dateOfBirth
    }
    
    func setLanguageSpecificText() {
        firstNameLabel.text = NSLocalizedString("firstName", comment: "")
        surnameLabel.text = NSLocalizedString("surname", comment: "")
        dateOfBirthLabel.text = NSLocalizedString("dateOfBirth", comment: "")
        usernameLabel.text = NSLocalizedString("email", comment: "")
        passwordLabel.text = NSLocalizedString("password", comment: "")
        confirmPasswordLabel.text = NSLocalizedString("confirmPassword", comment: "")
        
        personalInfoLabel.text = NSLocalizedString("personalInfo", comment: "")
        loginInfoLabel.text = NSLocalizedString("loginInfo", comment: "")
        editPatientButton.setTitle(NSLocalizedString("createPatient", comment: ""), for: .normal)
    }
    
    @IBAction func confirmEdit(_ sender: Any) {
        if(allRequiredFieldsFilled()) {
            // TODO: Patientgegevens bewerken call van API
            addDietaryGuidelinesToTheDatabase()
        }
        else {
            // TODO: Message - Not all fields filled
        }
    }
    
    
    func createRestrictionPicker() {
        restrictionPicker.dataSource = self
        restrictionPicker.delegate = self
    }
    
    func setupGuidelineFields() {
        guideline1.inputView = restrictionPicker
        guideline2.inputView = restrictionPicker
        guideline3.inputView = restrictionPicker
        guideline4.inputView = restrictionPicker
        guideline5.inputView = restrictionPicker
        guideline6.inputView = restrictionPicker
        guideline1.delegate = self
        guideline2.delegate = self
        guideline3.delegate = self
        guideline4.delegate = self
        guideline5.delegate = self
        guideline6.delegate = self
        amount1.delegate = onlyAllowNumbersDelegate
        amount2.delegate = onlyAllowNumbersDelegate
        amount3.delegate = onlyAllowNumbersDelegate
        amount4.delegate = onlyAllowNumbersDelegate
        amount5.delegate = onlyAllowNumbersDelegate
        amount6.delegate = onlyAllowNumbersDelegate
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
    
    func addDietaryGuidelinesToTheDatabase() {
        var guidelines : [DietaryManagement] = []
        if(guideline1.text != "" && amount1.text != "") {
            guidelines.append(DietaryManagement(id: 0, description: guideline1.text!, amount: Int(amount1.text!) ?? 0, isActive: true, patientId: patientId))
        }
        if(guideline2.text != "" && amount2.text != "") {
            guidelines.append(DietaryManagement(id: 0, description: guideline2.text!, amount: Int(amount2.text!) ?? 0, isActive: true, patientId: patientId))
        }
        if(guideline3.text != "" && amount3.text != "") {
            guidelines.append(DietaryManagement(id: 0, description: guideline3.text!, amount: Int(amount3.text!) ?? 0, isActive: true, patientId: patientId))
        }
        if(guideline4.text != "" && amount4.text != "") {
            guidelines.append(DietaryManagement(id: 0, description: guideline4.text!, amount: Int(amount4.text!) ?? 0, isActive: true, patientId: patientId))
        }
        if(guideline5.text != "" && amount5.text != "") {
            guidelines.append(DietaryManagement(id: 0, description: guideline5.text!, amount: Int(amount5.text!) ?? 0, isActive: true, patientId: patientId))
        }
        if(guideline6.text != "" && amount6.text != "") {
            guidelines.append(DietaryManagement(id: 0, description: guideline6.text!, amount: Int(amount6.text!) ?? 0, isActive: true, patientId: patientId))
        }
        print(guidelines.count)
        for guideline in guidelines {
            print(guideline.description)
            print(guideline.amount)
            NiZiAPIHelper.createDietaryManagement(forPatient: patientId, withGuideline: guideline, authenticationCode: "").response(completionHandler: { response in
                print(response.data)
                guard let jsonResponse = response.data else { return }
                print(String(data: jsonResponse, encoding: String.Encoding.utf8))
            })
        }
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
       if let x = string.rangeOfCharacter(from: NSCharacterSet.decimalDigits) {
          return true
       } else {
          return false
       }
    }
}
