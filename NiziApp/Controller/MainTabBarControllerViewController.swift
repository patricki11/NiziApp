//
//  MainTabBarControllerViewController.swift
//  NiziApp
//
//  Created by Wing lam on 11/12/2019.
//  Copyright © 2019 Samir Yeasin. All rights reserved.
//


import UIKit
import SwiftKeychainWrapper

class MainTabBarController: UITabBarController {
    var token : String?
    var user : NewUser?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //token = "Yello"
        
        //let finalVC = self.viewControllers![0] as! HomeViewController //first view controller in the tabbar
        //finalVC.dataTransferTo = token!
    }
}

