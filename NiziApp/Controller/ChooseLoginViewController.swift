//
//  ChooseLoginViewController.swift
//  NiziApp
//
//  Created by Samir Yeasin on 09/12/2019.
//  Copyright © 2019 Samir Yeasin. All rights reserved.
//

import Foundation
import UIKit
import SwiftKeychainWrapper

class ChooseLoginViewController : UIViewController {
    
    @IBOutlet weak var loginAsPatientButton: UIButton!
    @IBOutlet weak var loginAsDietistButton: UIButton!
    
    func checkIfLoggedIn() {
        guard let authToken = KeychainWrapper.standard.string(forKey: "authToken") else { print("No authToken saved"); return }
        
        login(withSavedToken: authToken)
    }
    
    func login(withSavedToken authToken: String) {
        NiZiAPIHelper.login(withToken: authToken).responseData(completionHandler: { response in
            guard let jsonResponse = response.data
                else { print("Failed to log in"); return }
            
            let jsonDecoder = JSONDecoder()
            guard let account = try? jsonDecoder.decode(NewUser.self, from: jsonResponse)
                else { print("Unable to decode data"); return }
            
            let isPatientAccount = false // TODO: Get patient or doctor id from call
            
            if(isPatientAccount) {
                self.navigateToPatientHomepage(withPatient: account, withPatientCode: authToken)
            }
            else {
                self.navigateToPatientList(withAccount: account)
            }
        })
    }
    
    func navigateToPatientList(withAccount doctorAccount: NewUser) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let patientListVC = storyboard.instantiateViewController(withIdentifier: "PatientListViewController") as! PatientListViewController
        //patientListVC.loggedInAccount = DoctorLogin() // doctorAccount
        self.navigationController?.pushViewController(patientListVC, animated: true)
    }

    
    func navigateToPatientHomepage(withPatient patientAccount: NewUser, withPatientCode: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeVC = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as! MainTabBarController
        homeVC.token = withPatientCode
        self.navigationController?.pushViewController(homeVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfLoggedIn()
        title = NSLocalizedString("ApplicationName", comment: "")
        setLanguageSpecificText()
        self.navigationItem.hidesBackButton = true
        removeKeyboardAfterClickingOutsideField()
    }
    
    func setLanguageSpecificText() {
        loginAsPatientButton.setTitle(NSLocalizedString("loginAsPatient", comment: ""), for: .normal)
        loginAsDietistButton.setTitle(NSLocalizedString("loginAsDietist", comment: ""), for: .normal)
    }
    
    @IBAction func navigateToPatientLogin(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        loginVC.isPatient = true
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    @IBAction func navigateToDietistLogin(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        loginVC.isDietist = true
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
}
