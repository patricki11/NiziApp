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
        guard let authToken = KeychainWrapper.standard.string(forKey: "authToken") else { return }
        
        let isPatientAccount = KeychainWrapper.standard.string(forKey: "patientId") != nil
        if(isPatientAccount) {
            patientLoginToApi(authToken: authToken)
        }
        else {
            dietistLoginToApi(authToken: authToken)
        }
    }
    
    func patientLoginToApi(authToken: String) {
        NiZiAPIHelper.login(withPatientCode: authToken).responseData(completionHandler: { response in
            guard let jsonResponse = response.data
                else { print("temp1"); return }
            
            let jsonDecoder = JSONDecoder()
            guard let patientAccount = try? jsonDecoder.decode(PatientLogin.self, from: jsonResponse )
                else { print("temp2"); return }
            
            self.navigateToPatientHomepage(withPatient: patientAccount, withPatientCode: authToken)
        })
    }
    
    func dietistLoginToApi(authToken: String) {
        NiZiAPIHelper.login(withDoctorCode: authToken).responseData(completionHandler: { response in
            guard let jsonResponse = response.data
            else { return }
            
            let jsonDecoder = JSONDecoder()
            guard let doctorAccount = try? jsonDecoder.decode(DoctorLogin.self, from: jsonResponse )
            else { return }
            
            self.navigateToPatientList(withAccount: doctorAccount)
        })
    }
    
    func navigateToPatientList(withAccount doctorAccount: DoctorLogin) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let patientListVC = storyboard.instantiateViewController(withIdentifier: "PatientListViewController") as! PatientListViewController
        patientListVC.loggedInAccount = doctorAccount
        self.navigationController?.pushViewController(patientListVC, animated: true)
    }

    
    func navigateToPatientHomepage(withPatient patientAccount: PatientLogin, withPatientCode: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeVC = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as! MainTabBarController
        homeVC.token = withPatientCode
        self.navigationController?.pushViewController(homeVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfLoggedIn()
        title = NSLocalizedString("ApplicationName", comment: "");
        setLanguageSpecificText()
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
