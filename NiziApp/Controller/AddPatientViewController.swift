//
//  AddPatientViewController.swift
//  NiziApp
//
//  Created by Samir Yeasin on 29/11/2019.
//  Copyright © 2019 Samir Yeasin. All rights reserved.
//

import UIKit
import Foundation

class AddPatientViewController: UIViewController {

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
    
    @IBOutlet weak var addPatientButton: UIButton!
    
    func datePicker() -> UIDatePicker {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.addTarget(self, action: #selector(datePickerChanged(_:)), for: .valueChanged)
        return picker
    }
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
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
        dateOfBirthField.inputView = datePicker()
        title = NSLocalizedString("addPatient", comment: "")
        setLanguageSpecificText()
    }
    
    func setLanguageSpecificText() {
        firstNameLabel.text = NSLocalizedString("firstName", comment: "")
        surnameLabel.text = NSLocalizedString("surname", comment: "")
        dateOfBirthLabel.text = NSLocalizedString("dateOfBirth", comment: "")
        usernameLabel.text = NSLocalizedString("username", comment: "")
        passwordLabel.text = NSLocalizedString("password", comment: "")
        confirmPasswordLabel.text = NSLocalizedString("confirmPassword", comment: "")
        
        personalInfoLabel.text = NSLocalizedString("personalInfo", comment: "")
        loginInfoLabel.text = NSLocalizedString("loginInfo", comment: "")
         addPatientButton.setTitle(NSLocalizedString("createPatient", comment: ""), for: .normal)
    }
    
    @IBAction func addPatient(_ sender: Any) {
        
    }
    
    func requiredFieldsAreFilled() -> Bool {
        let firstName = firstNameField.text ?? ""
        let surname = surnameField.text ?? ""
        let dateOfBirth = dateOfBirthField.text ?? ""
        let username = usernameField.text ?? ""
        let password = passwordField.text ?? ""
        let confirmedPassword = confirmPasswordField.text ?? ""
        
        return firstName != "" && surname != "" && dateOfBirth != "" && username != "" && password != "" && confirmedPassword != ""
    }
    
    func passwordIsValid() -> Bool {
        let password = passwordField.text
        let confirmPassword = confirmPasswordField.text
        
        if(passwordMatches() && isStrongPassword()) {
            return true
        }
        else {
            return false
        }
    }
    
    func isStrongPassword() -> Bool {
        return passwordContainsLowercaseLetters() && passwordContainsUppercaseLetters() && passwordContainsNumber() && passwordContainsSpecialCharacter()
    }
    
    func passwordContainsSpecialCharacter() -> Bool {
        let password = passwordField.text ?? ""
        
        let charset = CharacterSet(charactersIn: "!@#$%^&*")

        if let _ = password.rangeOfCharacter(from: charset, options: .caseInsensitive) {
           return true
        }
        else {
           return false
        }

    }
    
    func passwordContainsLowercaseLetters() -> Bool {
        let password = passwordField.text ?? ""
        
        let charset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz")

        if let _ = password.rangeOfCharacter(from: charset) {
           return true
        }
        else {
           return false
        }
    }
    
    func passwordContainsUppercaseLetters() -> Bool {
        let password = passwordField.text ?? ""
        
        let charset = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZ")

        if let _ = password.rangeOfCharacter(from: charset) {
           return true
        }
        else {
           return false
        }
    }
    
    func passwordContainsNumber() -> Bool {
        let password = passwordField.text ?? ""
        
        let charset = CharacterSet(charactersIn: "0123456789")

        if let _ = password.rangeOfCharacter(from: charset) {
           return true
        }
        else {
           return false
        }
    }
    
    func passwordMatches() -> Bool {
        let password = passwordField.text
        let confirmPassword = confirmPasswordField.text
        
        return password == confirmPassword
    }
    
    func createNewPatientInDatabase() {
        var newPatient = Patient(patientId: 0, accountId: 0, doctorId: 3, firstName: firstNameField.text!, lastName: surnameField.text!, dateOfBirth: Date(), guid: "", weightInKg: 0.00)
    }
}
