//
//  LoginViewController.swift
//  Nizi iOS Applicatie
//
//  Created by Informatica Haarlem on 19-11-19.
//  Copyright © 2019 De Mobiele Jongens. All rights reserved.
//

import Foundation
import UIKit
import Auth0

class LoginViewController : UIViewController {
    
    @IBOutlet weak var applicationNameLabel: UILabel!
    @IBOutlet weak var pageTitleLabel: UILabel!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var needHelpLabel: UILabel!
    @IBOutlet weak var needHelpDescription: UILabel!
    
    @IBOutlet weak var LoginPatientButton: UIButton!
    @IBOutlet weak var LoginDietistButton: UIButton!
    
    @IBOutlet weak var nierstichtingWebImage: UIImageView!
    @IBOutlet weak var nierstrichtingPhoneImage: UIImageView!
    @IBOutlet weak var nierstrichtingMailImage: UIImageView!
    
    @IBOutlet weak var nierstichtingWebLabel: UILabel!
    @IBOutlet weak var nierstichtingPhoneLabel: UILabel!
    @IBOutlet weak var nierstichtingPhoneTimeLabel: UILabel!
    @IBOutlet weak var nierstichtingMailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setLanguageSpecificText()
    }
    
    func setLanguageSpecificText() {
        applicationNameLabel.text = NSLocalizedString("ApplicationName", comment: "Nizi")
        pageTitleLabel.text = NSLocalizedString("LoginPageTitle", comment: "")
        usernameLabel.text = NSLocalizedString("UsernameLabel", comment: "")
        passwordLabel.text = NSLocalizedString("PasswordLabel", comment: "")
        needHelpLabel.text = NSLocalizedString("NeedHelp", comment: "")
        needHelpDescription.text = NSLocalizedString("NeedHelpSubtitle", comment: "")
        
        // Temporary Titles
        LoginDietistButton.setTitle("Dietist", for: .normal)
        LoginPatientButton.setTitle("Patient", for: .normal)
        //LoginButton.setTitle("Login", for: .normal)
        nierstichtingWebLabel.text = NSLocalizedString("NierstichtingWeb", comment: "")
        nierstichtingPhoneLabel.text = NSLocalizedString("NierstichtingPhone", comment: "")
        nierstichtingPhoneTimeLabel.text = NSLocalizedString("NierstichtingPhoneTime", comment: "")
        nierstichtingMailLabel.text = NSLocalizedString("NierstichtingMail", comment: "")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func LoginPatient(_ sender: Any) {
        let username = usernameField.text ?? ""
        let password = passwordField.text ?? ""
        Auth0
            .authentication()
            .login(
            usernameOrEmail: username,
            password: password,
            realm: "Username-Password-Authentication",
            audience: "appnizi.nl/api",
            scope: "openid profile")
            .start { result in
                switch result {
                case .success(let credentials):
                    self.patientLoginToApi(credentials: credentials)
                case .failure(let error):
                    print("Failed with \(error)")
                    self.showFailedToLoginMessage()
                }
        }
    }
    
    func patientLoginToApi(credentials: Credentials) {
        NiZiAPIHelper.login(withPatientCode: credentials.accessToken!).responseData(completionHandler: { response in
            print(response.response)
        })
    }
    
    func dietistLoginToApi(credentials: Credentials) {
        NiZiAPIHelper.login(withDoctorCode: credentials.accessToken!).responseData(completionHandler: { response in
            print(response.response)
            
            switch(response.response?.statusCode) {
            case 200:
                self.navigateToPatientList()
            case 401:
                self.showUnauthorizedMessage()
            case .none:
                break
            case .some(_):
                break
            }
        })
    }
    
    func navigateToPatientList() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let patientListVC = storyboard.instantiateViewController(withIdentifier: "PatientListViewController") as! PatientListViewController
        self.navigationController?.pushViewController(patientListVC, animated: true)
    }
    
    @IBAction func LoginDietist(_ sender: Any) {
        let username = usernameField.text ?? ""
        let password = passwordField.text ?? ""
        Auth0
            .authentication()
            .login(
            usernameOrEmail: username,
            password: password,
            realm: "Username-Password-Authentication",
            audience: "appnizi.nl/api",
            scope: "openid profile")
            .start { result in
                switch result {
                case .success(let credentials):
                    NiZiAPIHelper.login(withDoctorCode: credentials.accessToken!).responseData(completionHandler: { response in
                        print(response)
                    })
                case .failure(let error):
                    print("Failed with \(error)")
                    self.showFailedToLoginMessage()
                }
        }
    }
    
    func showFailedToLoginMessage() {
        let alertController = UIAlertController(
            title: NSLocalizedString("wrongCredentialsTitle", comment: "Title"),
            message: NSLocalizedString("wrongCredentialsMessage", comment: "Message"),
            preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "Ok"), style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showUnauthorizedMessage() {
        let alertController = UIAlertController(
            title: "TODO",
            message: "User is not authorized message",
            preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "Ok"), style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
}
