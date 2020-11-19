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
import SwiftKeychainWrapper

class LoginViewController : UIViewController {
    
    @IBOutlet weak var applicationNameLabel: UILabel!
    @IBOutlet weak var pageTitleLabel: UILabel!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var needHelpLabel: UILabel!
    @IBOutlet weak var needHelpDescription: UILabel!
    
    @IBOutlet weak var LoginButton: UIButton!
    
    @IBOutlet weak var nierstichtingWebImage: UIImageView!
    @IBOutlet weak var nierstrichtingPhoneImage: UIImageView!
    @IBOutlet weak var nierstrichtingMailImage: UIImageView!
    
    @IBOutlet weak var nierstichtingWebLabel: UILabel!
    @IBOutlet weak var nierstichtingPhoneLabel: UILabel!
    @IBOutlet weak var nierstichtingPhoneTimeLabel: UILabel!
    @IBOutlet weak var nierstichtingMailLabel: UILabel!
    
    var isPatient : Bool = false
    var isDietist : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = NSLocalizedString("login", comment: "")
        checkIfLoggedIn()
        setLanguageSpecificText()
        removeKeyboardAfterClickingOutsideField()
    }
    
    func setLanguageSpecificText() {
        pageTitleLabel.text = NSLocalizedString("LoginPageTitle", comment: "")
        usernameLabel.text = NSLocalizedString("UsernameLabel", comment: "")
        passwordLabel.text = NSLocalizedString("PasswordLabel", comment: "")
        needHelpLabel.text = NSLocalizedString("NeedHelp", comment: "")
        needHelpDescription.text = NSLocalizedString("NeedHelpSubtitle", comment: "")
        LoginButton.setTitle("Login", for: .normal)
        nierstichtingWebLabel.text = NSLocalizedString("NierstichtingWeb", comment: "")
        nierstichtingPhoneLabel.text = NSLocalizedString("NierstichtingPhone", comment: "")
        nierstichtingPhoneTimeLabel.text = NSLocalizedString("NierstichtingPhoneTime", comment: "")
        nierstichtingMailLabel.text = NSLocalizedString("NierstichtingMail", comment: "")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func savePatientId(patientId: String) {
        KeychainWrapper.standard.set(patientId, forKey: "patientId")
    }
    
    func saveAuthToken(token: String) {
        KeychainWrapper.standard.set(token, forKey: "authToken")
    }
    
    func checkIfLoggedIn() {
        guard let authToken = KeychainWrapper.standard.string(forKey: "authToken") else { print("No authToken saved"); return }
        
        //print(authToken)
        
        login(withSavedToken: authToken)
    }
    
    func login(withSavedToken authToken: String) {
        NiZiAPIHelper.login(withToken: authToken).responseData(completionHandler: { response in
            guard let jsonResponse = response.data
                else { print("Failed to log in"); return }
            
            let jsonDecoder = JSONDecoder()
            guard let account = try? jsonDecoder.decode(NewUser.self, from: jsonResponse)
                else { print("Unable to decode data"); return }
            
            if(account.patient != nil) {
                self.navigateToPatientHomepage(withPatient: account, withPatientCode: authToken)
            }
            else if(account.doctor != nil) {
                self.navigateToPatientList(withAccount: account)
            }
        })
    }
    
    func navigateToPatientList(withAccount doctorAccount: NewUser) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let patientListVC = storyboard.instantiateViewController(withIdentifier: "PatientListViewController") as! PatientListViewController
        patientListVC.loggedInAccount = doctorAccount

        self.navigationController?.pushViewController(patientListVC, animated: true)
    }

    
    func navigateToPatientHomepage(withPatient patientAccount: NewUser, withPatientCode: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeVC = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as! MainTabBarController
        homeVC.token = withPatientCode
        self.navigationController?.pushViewController(homeVC, animated: true)
    }
    
    
    @IBAction func LoginButton(_ sender: Any) {
        let username = usernameField.text ?? ""
        let password = passwordField.text ?? ""
        
        NiZiAPIHelper.login(withUsername: username, andPassword: password).responseData(completionHandler: { response in
            
            guard let jsonResponse = response.data else { return }
            
            if(response.response?.statusCode == 400) {
                self.showFailedToLoginMessage()
                return
            }
            
            var result = String(data: response.data!, encoding: .utf8)
            //print(result)
            
            var jsonDecoder = JSONDecoder()
            guard let login = try? jsonDecoder.decode(NewUserLogin.self, from: jsonResponse) else { print("Unable to decode form json"); return }
            
            self.saveAuthToken(token: login.jwt!)
            
            if(login.user.role?.description == "Patient") {
                self.navigateToPatientHomepage(withPatient: login.user, withPatientCode: login.jwt!)
            }
            else if(login.user.role?.description == "Doctor"){
                self.navigateToPatientList(withAccount: login.user)
            }
        })
    }
    
    func showFailedToLoginMessage() {
        DispatchQueue.main.async {
            let alertController = UIAlertController(
                title: NSLocalizedString("wrongCredentialsTitle", comment: "Title"),
                message: NSLocalizedString("wrongCredentialsMessage", comment: "Message"),
                preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "Ok"), style: .default, handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
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
