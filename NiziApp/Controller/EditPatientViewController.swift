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
    
    var patientInfo : PatientPersonalInfo? = nil
    var patientId : Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Bewerken Patiënt"
        getPatientObject()
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
        }
        else {
            // TODO: Message - Not all fields filled
        }
    }
    
    func getPatientObject() {
        NiZiAPIHelper.getPatient(byId: patientId, authenticationCode: KeychainWrapper.standard.string(forKey: "authToken")!).response(completionHandler: { response in
            guard let jsonResponse = response.data else { return }
            print(String(data: jsonResponse, encoding: String.Encoding.utf8))
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
