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
    
    @IBOutlet weak var personalInfoLabel: UILabel!
    @IBOutlet weak var loginInfoLabel: UILabel!
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var surnameField: UITextField!
    @IBOutlet weak var dateOfBirthField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    @IBOutlet weak var addPatientButton: UIButton!
    
    weak var loggedInAccount : DoctorLogin!
    
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
        dateOfBirthField.inputView = datePicker()
        title = NSLocalizedString("addPatient", comment: "")
        setLanguageSpecificText()
        print(loggedInAccount)
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
        addPatientButton.setTitle(NSLocalizedString("createPatient", comment: ""), for: .normal)
        passwordRequirementLabel.text = "Het wachtwoord moet minimaal aan 3 van de 4 volgende eisen voldoen: 1 kleine letter, 1 hoofdletter, 1 cijfer, 1 speciaal teken (!@#$%^&*)"
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

        createPatientAccount()

        
    }
    
    func createPatientAccount() {
        Auth0
        .authentication()
        .createUser(
            email: usernameField.text!,
            password: passwordField.text!,
            connection: "Username-Password-Authentication",
            userMetadata: ["first_name": firstNameField.text,
                           "last_name": surnameField.text]
        )
        .start { result in
            switch result {
            case .success(let user):
                print("User Signed up: \(user)")
                self.addPatientToAPIDatabase()
            case .failure(let error):
                print("Failed with \(error)")
            }
        }
    }
    
    func addPatientToAPIDatabase() {
        DispatchQueue.main.async {
            Auth0
            .authentication()
            .login(
                usernameOrEmail: self.usernameField.text!,
                password: self.passwordField.text!,
                realm: "Username-Password-Authentication",
                audience: "appnizi.nl/api",
                scope: "openid profile"
            )
            .start { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let credentials):
                        Auth0
                        .authentication()
                        .userInfo(withAccessToken: credentials.accessToken!)
                        .start { result in
                            switch result {
                            case .success(let result):
                                let patient = self.createNewPatientObject(firstName: self.firstNameField.text!, lastName: self.surnameField.text!, dateOfBirth: self.dateOfBirthField.text!, credentials: credentials, userInfo: result)
                                NiZiAPIHelper.addPatient(withDetails: patient, authenticationCode: KeychainWrapper.standard.string(forKey: "authToken")!).responseData(completionHandler: { response in
                                    self.getPatientDataFromDatabase(patient: patient)
                                })
                            case .failure(let error):
                                print(error)
                            }
                            
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
    }
    
    func getPatientDataFromDatabase(patient: PatientLogin) {
        NiZiAPIHelper.login(withToken: (patient.auth?.token?.accessCode!)!).responseData(completionHandler: { response in
            print("accessCode: ", patient.auth?.token?.accessCode)
            print("auth-guid: ", patient.auth?.guid)
            print("patient-guid: ", patient.patient?.guid)
            print("response: ", response.data)
            guard let jsonResponse = response.data
                else { return }
            
            let jsonDecoder = JSONDecoder()
            guard let patientFromDatabase = try? jsonDecoder.decode(PatientLogin.self, from: jsonResponse)
                else { return }
            
            self.showPatientAddedMessage(patient: patientFromDatabase)
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
    
    func createNewPatientObject(firstName: String, lastName: String, dateOfBirth: String, credentials: Credentials, userInfo: UserInfo) -> PatientLogin {
        let dateFormatterFrom = DateFormatter()
        dateFormatterFrom.dateFormat = "dd-MM-YYYY"
        print("dokter auth: ", KeychainWrapper.standard.string(forKey: "authToken"))
        let dateFormatterTo = DateFormatter()
        dateFormatterTo.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let date : Date = dateFormatterFrom.date(from: dateOfBirth) ?? Date()
        print(dateFormatterTo.string(from: date))
        print(userInfo.sub)
        let account : Account = Account(
            accountId: 0,
            role: "Patient"
        )
        let patient : Patient = Patient(
            patientId: 0,
            accountId: 0,
            doctorId: 3,//self.loggedInAccount.doctor?.doctorId,
            firstName: firstName,
            lastName: lastName,
            dateOfBirth: dateFormatterTo.string(from: date),
            guid: userInfo.sub,
            weightInKg: 0.00
        )
        let token : Token? = Token(
            scheme: "Bearer",
            accessCode: credentials.accessToken
        )
        let auth: Auth? = Auth(
            guid: userInfo.sub,
            token: token
        )
        
        let doctor : Doctor = Doctor(doctorId: 3, firstName: "Dr", lastName: "Pepper", location: "")
        
        return PatientLogin(
            account: account,
            doctor: doctor,//self.loggedInAccount.doctor,
            patient: patient,
            auth: auth
        )
                 
    }
    
    func showRequiredFieldsNotFilledMessage() {
        let alertController = UIAlertController(
            title: "Niet aangemaakt",
            message: "Niet alle verplichte velden zijn ingevuld.",
            preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "Ok"), style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showPasswordDoesNotMatchMessage() {
        let alertController = UIAlertController(
            title: "Niet aangemaakt",
            message: "Het ingegeven wachtwoord komt niet overeen",
            preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "Ok"), style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showPatientAddedMessage(patient: PatientLogin) {
        let alertController = UIAlertController(
            title: "Patiënt toegevoegd",
            message: "De patiënt is toegevoegd.",
            preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "Ok"), style: .default, handler: { _ in self.navigateToGuidelineController(patient: patient)}))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showIncorrectEmailFormatMessage() {
        let alertController = UIAlertController(
            title: "Niet aangemaakt",
            message: "Het ingegeven emailadres is niet valide.",
            preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "Ok"), style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showPasswordNotStrongEnoughMessage() {
        let alertController = UIAlertController(
            title: "Niet aangemaakt",
            message: "Het ingegeven wachtwoord is niet sterk genoeg, het wachtwoord moet minimaal 1 hoofdletter, 1 kleine letter, 1 cijfer en 1 speciale teken () bevatten.",
            preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "Ok"), style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func navigateToGuidelineController(patient: PatientLogin) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let guidelineVC = storyboard.instantiateViewController(withIdentifier: "AddPatientGuidelinesViewController") as! AddPatientGuidelinesViewController
        guidelineVC.patient = patient.patient
        self.navigationController?.pushViewController(guidelineVC, animated: true)
    }
}

extension UIViewController {
    func removeKeyboardAfterClickingOutsideField() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
}
