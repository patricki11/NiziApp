//
//  CreateMealViewController.swift
//  NiziApp
//
//  Created by Wing lam on 04/01/2020.
//  Copyright © 2020 Samir Yeasin. All rights reserved.
//

import UIKit

class CreateMealViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
}
