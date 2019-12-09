//
//  ChooseLoginViewController.swift
//  NiziApp
//
//  Created by Samir Yeasin on 09/12/2019.
//  Copyright © 2019 Samir Yeasin. All rights reserved.
//

import Foundation
import UIKit

class ChooseLoginViewController : UIViewController {
    
    @IBOutlet weak var loginAsPatientButton: UIButton!
    @IBOutlet weak var loginAsDietistButton: UIButton!
    
    
    override func viewDidLoad() {
           super.viewDidLoad()
           // Do any additional setup after loading the view, typically from a nib.
        title = NSLocalizedString("ApplicationName", comment: "");
           setLanguageSpecificText()
    }
    
    func setLanguageSpecificText() {
        loginAsPatientButton.setTitle(NSLocalizedString("lginAsPatient", comment: ""), for: .normal)
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
