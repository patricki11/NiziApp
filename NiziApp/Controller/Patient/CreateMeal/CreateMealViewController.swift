//
//  CreateMealViewController.swift
//  NiziApp
//
//  Created by Wing lam on 04/01/2020.
//  Copyright © 2020 Samir Yeasin. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Kingfisher

class CreateMealViewController: UIViewController {
    
    let patientIntID : Int? = Int(KeychainWrapper.standard.string(forKey: "patientId")!)
    
    var Mealfoodlist : [Food] = []
    var kcal : Double = 0.0
    var fiberMeal : Double = 0.0
    var vochtMeal : Double = 0.0
    var pottassiumMeal : Double = 0.0
    var sodiumMeal : Double = 0.0
    var proteinMeal : Double = 0.0
    
    
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var NameText: UITextField!
    @IBOutlet weak var MealProducts: UITableView!
    @IBOutlet weak var KcalLabel: UILabel!
    @IBOutlet weak var FiberLabel: UILabel!
    @IBOutlet weak var ProteinLabel: UILabel!
    @IBOutlet weak var VochtLabel: UILabel!
    @IBOutlet weak var SodiumLabel: UILabel!
    @IBOutlet weak var PotassiumLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool){
        MealProducts?.reloadData()
    }
    
    
}
