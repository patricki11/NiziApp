//
//  AddPatientViewController.swift
//  NiziApp
//
//  Created by Samir Yeasin on 29/11/2019.
//  Copyright © 2019 Samir Yeasin. All rights reserved.
//

import UIKit
import Foundation
import Auth0
import SwiftKeychainWrapper

class AddPatientViewController: UIViewController {

    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var surnameLabel: UILabel!
    @IBOutlet weak var dateOfBirthLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var confirmPasswordLabel: UILabel!
    @IBOutlet weak var passwordRequirementLabel: UILabel!
    
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var genderManButton: UIButton!
    @IBOutlet weak var genderWomanButton: UIButton!
    @IBOutlet weak var genderManLabel: UILabel!
    @IBOutlet weak var genderWomanLabel: UILabel!
    
    @IBOutlet weak var personalInfoLabel: UILabel!
    @IBOutlet weak var loginInfoLabel: UILabel!
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var surnameField: UITextField!
    @IBOutlet weak var dateOfBirthField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    @IBOutlet weak var addPatientButton: UIButton!
    
    weak var loggedInAccount : NewUser!
    
    var newPatient : NewPatient!
    var newUser : NewUser!
    
    var gender: String = ""
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
    
    @IBAction func genderManSelected(_ sender: Any) {
        gender = "Man"
        genderManButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        genderWomanButton.setImage(UIImage(systemName: "circle"), for: .normal)
    }
    
    @IBAction func genderWomanSelected(_ sender: Any) {
        gender = "Vrouw"
        genderManButton.setImage(UIImage(systemName: "circle"), for: .normal)
        genderWomanButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
    }
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
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
        title = NSLocalizedString("AddPatient", comment: "")
        setLanguageSpecificText()
        removeKeyboardAfterClickingOutsideField()
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
        addPatientButton.setTitle(NSLocalizedString("nextStep", comment: ""), for: .normal)
        passwordRequirementLabel.text = NSLocalizedString("passwordRequirement", comment: "")
        
        genderLabel.text = NSLocalizedString("Gender", comment: "")
        genderManLabel.text = NSLocalizedString("Man", comment: "")
        genderWomanLabel.text = NSLocalizedString("Woman", comment: "")
    }
    
    @IBAction func addPatient(_ sender: Any) {
        if(!isValidEmail()) {
            showIncorrectEmailFormatMessage()
            return
        }
        
        if(!requiredFieldsAreFilled()) {
            showRequiredFieldsNotFilledMessage()
            return
        }
        
        if(!passwordMatches()) {
            showPasswordDoesNotMatchMessage()
            return
        }
        
        if(!isStrongPassword()) {
            showPasswordNotStrongEnoughMessage()
            return
        }

        createPatientAccountObjects()
    }
    
    func createPatientAccountObjects() {
        newPatient = NewPatient(id: nil, gender: gender, dateOfBirth: self.dateOfBirthField.text!, createdAt: "",updatedAt: "", doctor: loggedInAccount.doctor!, user: nil)
       
       newUser = NewUser(id: 0, password: self.passwordField.text!, username: self.usernameField.text!, email: self.usernameField.text!, provider: "local", confirmed: false, role: 4, created_at: "", updated_at: "", firstname: self.firstNameField.text!, lastname: self.surnameField.text!, test: "", patient: nil, patientObject: nil, first_name: self.firstNameField.text!, last_name: self.surnameField.text!, doctor: nil)
       
        checkIfEmailExists()
    }

    func checkIfEmailExists() {
        NiZiAPIHelper.checkIfUserExists(email: newUser.email!, authenticationCode: KeychainWrapper.standard.string(forKey: "authToken")!).responseData(completionHandler: { response in
            
            guard let jsonResponse = response.data else { return }

            var jsonDecoder = JSONDecoder()
            
            guard let users = try? jsonDecoder.decode([NewUser].self, from: jsonResponse) else { return }
            
            if(users.count > 0) {
                self.showPatientAlreadyExistsMessage()
            }
            else {
                self.navigateToGuidelineController()
            }
        })
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
    
    func isStrongPassword() -> Bool {
        var strongCounter = 0
        if(passwordContainsLowercaseLetters()) {
            strongCounter+=1
        }
        if(passwordContainsUppercaseLetters()){
            strongCounter+=1
        }
        if(passwordContainsNumber()) {
            strongCounter+=1
        }
        if(passwordContainsSpecialCharacter()) {
            strongCounter+=1
        }
        
        // Auth0 Requires a minimum of 3 of the conditions to be true
        return strongCounter >= 3
    }
    
    func isValidEmail() -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: usernameField.text!)
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
    
    func showRequiredFieldsNotFilledMessage() {
        let alertController = UIAlertController(
            title: NSLocalizedString("requiredFieldsTitle", comment: ""),
            message: NSLocalizedString("requiredFieldsMessage", comment: ""),
            preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "Ok"), style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showPasswordDoesNotMatchMessage() {
        let alertController = UIAlertController(
            title: NSLocalizedString("passwordDoesNotMatchTitle", comment: ""),
            message: NSLocalizedString("passwordDoesNotMatchMessage", comment: ""),
            preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "Ok"), style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showIncorrectEmailFormatMessage() {
        let alertController = UIAlertController(
            title: NSLocalizedString("invalidEmailTitle", comment: ""),
            message: NSLocalizedString("invalidEmailMessage", comment: ""),
            preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "Ok"), style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showPasswordNotStrongEnoughMessage() {
        let alertController = UIAlertController(
            title: NSLocalizedString("passwordNotStrongEnoughTitle", comment: ""),
            message: NSLocalizedString("passwordNotStrongEnoughMessage", comment: ""),
            preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "Ok"), style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showPatientAlreadyExistsMessage() {
        let alertController = UIAlertController(
            title: NSLocalizedString("patientExistsTitle", comment: ""),
            message: NSLocalizedString("patientExistsMessage", comment: ""),
            preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "Ok"), style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func navigateToGuidelineController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let guidelineVC = storyboard.instantiateViewController(withIdentifier: "AddPatientGuidelinesViewController") as! AddPatientGuidelinesViewController
        guidelineVC.newPatient = newPatient
        guidelineVC.newUser = newUser
        self.navigationController?.pushViewController(guidelineVC, animated: true)
    }
}

extension UIViewController {
    func removeKeyboardAfterClickingOutsideField() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
}
