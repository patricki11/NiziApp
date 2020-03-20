//
//  AddPatientGuidelinesViewController.swift
//  NiziApp
//
//  Created by Samir Yeasin on 20/03/2020.
//  Copyright © 2020 Samir Yeasin. All rights reserved.
//

import Foundation
import UIKit

class AddPatientGuidelinesViewController : UIViewController {
    
    @IBOutlet weak var caloriesTitle: UILabel!
    @IBOutlet weak var caloriesMinimumTitle: UILabel!
    @IBOutlet var caloriesMinimumField: UITextField!
    @IBOutlet weak var caloriesMaximumTitle: UILabel!
    @IBOutlet var caloriesMaximumField: UITextField!
    
    
    @IBOutlet weak var waterTitle: UILabel!
    @IBOutlet weak var waterMinimumTitle: UILabel!
    @IBOutlet weak var waterMinimumField: UITextField!
    @IBOutlet weak var waterMaximumTitle: UILabel!
    @IBOutlet weak var waterMaximumField: UITextField!
    
    @IBOutlet weak var sodiumTitle: UILabel!
    @IBOutlet weak var sodiumMinimumTitle: UILabel!
    @IBOutlet weak var sodiumMinimumField: UITextField!
    @IBOutlet weak var sodiumMaximumTitle: UILabel!
    @IBOutlet weak var sodiumMaximumField: UITextField!
    
    @IBOutlet weak var potassiumTitle: UILabel!
    @IBOutlet weak var potassiumMinimumTitle: UILabel!
    @IBOutlet weak var potassiumMinimumField: UITextField!
    @IBOutlet weak var potassiumMaximumTitle: UILabel!
    @IBOutlet weak var potassiumMaximumField: UITextField!
    
    @IBOutlet weak var proteinTitle: UILabel!
    @IBOutlet weak var proteinMinimumTitle: UILabel!
    @IBOutlet weak var proteinMinimumFIeld: UITextField!
    @IBOutlet weak var proteinMaximumTitle: UILabel!
    @IBOutlet weak var proteinMaximumField: UITextField!
    
    @IBOutlet weak var grainTitle: UILabel!
    @IBOutlet weak var grainMinimumTitle: UILabel!
    @IBOutlet weak var grainMinimumField: UITextField!
    @IBOutlet weak var grainMaximumTitle: UILabel!
    @IBOutlet weak var grainMaximumField: UITextField!
    
    @IBOutlet weak var savePatientButton: UIButton!
    
    var guidelines : [DietaryManagement] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setLanguageSpecificText()
        setNumericOnlyFields()
    }
    
    func setNumericOnlyFields() {
        caloriesMinimumField.delegate = OnlyAllowNumbersDelegate()
        caloriesMaximumField.delegate = OnlyAllowNumbersDelegate()
        waterMinimumField.delegate = OnlyAllowNumbersDelegate()
        waterMaximumField.delegate = OnlyAllowNumbersDelegate()
        sodiumMinimumField.delegate = OnlyAllowNumbersDelegate()
        sodiumMaximumField.delegate = OnlyAllowNumbersDelegate()
        potassiumMinimumField.delegate = OnlyAllowNumbersDelegate()
        potassiumMaximumField.delegate = OnlyAllowNumbersDelegate()
        proteinMinimumFIeld.delegate = OnlyAllowNumbersDelegate()
        proteinMaximumField.delegate = OnlyAllowNumbersDelegate()
        grainMinimumField.delegate = OnlyAllowNumbersDelegate()
        grainMaximumField.delegate = OnlyAllowNumbersDelegate()
    }
    
    func setLanguageSpecificText() {
        caloriesTitle.text = ""
        waterTitle.text = ""
        sodiumTitle.text = ""
        potassiumTitle.text = ""
        proteinTitle.text = ""
        grainTitle.text = ""
        
        caloriesMinimumTitle.text = ""
        waterMinimumTitle.text = ""
        sodiumMinimumTitle.text = ""
        potassiumMinimumTitle.text = ""
        proteinMinimumTitle.text = ""
        grainMinimumTitle.text = ""
        
        caloriesMaximumTitle.text = ""
        waterMaximumTitle.text = ""
        sodiumMaximumTitle.text = ""
        potassiumMaximumTitle.text = ""
        proteinMaximumTitle.text = ""
        grainMaximumTitle.text = ""
    }
    
    @IBAction func savePatientGuidelines(_ sender: Any) {
        getGuidelines()
        // TODO: Opslaan richtlijnen in DB
    }
    
    func getGuidelines() {
        addMinimumCaloriesGuideline()
        addMaximumCaloriesGuideline()
        addMinimumWaterGuideilne()
        addMaximumWaterGuideline()
        addMinimumSodiumGuideline()
        addMaximumSodiumGuideline()
        addMinimumPotassiumGuideline()
        addMaximumPotassiumGuideline()
        addMinimumProteinGuideline()
        addMaximumProteinGuideline()
    }
    
    func addMinimumCaloriesGuideline() {
        if(caloriesMinimumField.text != "") {
            guidelines.append(
                DietaryManagement(
                    id : 0,
                    description : "",
                    amount : Int(caloriesMinimumField.text!)!,
                    isActive : true,
                    patientId : 0
                )
            )
        }
    }
    
    func addMaximumCaloriesGuideline() {
        if(caloriesMaximumField.text != "") {
            guidelines.append(
                DietaryManagement(
                    id : 0,
                    description : "",
                    amount : Int(caloriesMaximumField.text!)!,
                    isActive : true,
                    patientId : 0
                )
            )
        }
    }
    
    func addMinimumWaterGuideilne() {
        if(waterMinimumField.text != "") {
            guidelines.append(
                DietaryManagement(
                    id : 0,
                    description : "",
                    amount : Int(waterMinimumField.text!)!,
                    isActive : true,
                    patientId : 0
                )
            )
        }
    }
    
    func addMaximumWaterGuideline() {
        if(waterMaximumField.text != "") {
            guidelines.append(
                DietaryManagement(
                    id : 0,
                    description : "",
                    amount : Int(waterMaximumField.text!)!,
                    isActive : true,
                    patientId : 0
                )
            )
        }
    }
    
    func addMinimumSodiumGuideline() {
        if(sodiumMinimumField.text != "") {
            guidelines.append(
                DietaryManagement(
                    id : 0,
                    description : "",
                    amount : Int(sodiumMinimumField.text!)!,
                    isActive : true,
                    patientId : 0
                )
            )
        }
    }
    
    func addMaximumSodiumGuideline() {
        if(sodiumMaximumField.text != "") {
            guidelines.append(
                DietaryManagement(
                    id : 0,
                    description : "",
                    amount : Int(sodiumMaximumField.text!)!,
                    isActive : true,
                    patientId : 0
                )
            )
        }
    }
    
    func addMinimumPotassiumGuideline() {
        if(potassiumMinimumField.text != "") {
            guidelines.append(
                DietaryManagement(
                    id : 0,
                    description : "",
                    amount : Int(potassiumMinimumField.text!)!,
                    isActive : true,
                    patientId : 0
                )
            )
        }
    }
    
    func addMaximumPotassiumGuideline() {
        if(potassiumMaximumField.text != "") {
            guidelines.append(
                DietaryManagement(
                    id : 0,
                    description : "",
                    amount : Int(potassiumMaximumField.text!)!,
                    isActive : true,
                    patientId : 0
                )
            )
        }
    }
    
    func addMinimumProteinGuideline() {
        if(proteinMinimumFIeld.text != "") {
            guidelines.append(
                DietaryManagement(
                    id : 0,
                    description : "",
                    amount : Int(proteinMinimumFIeld.text!)!,
                    isActive : true,
                    patientId : 0
                )
            )
        }
    }
    
    func addMaximumProteinGuideline() {
        if(proteinMaximumField.text != "") {
            guidelines.append(
                DietaryManagement(
                    id : 0,
                    description : "",
                    amount : Int(proteinMaximumField.text!)!,
                    isActive : true,
                    patientId : 0
                )
            )
        }
    }
    
    func addMinimumGrainGuideline() {
        if(grainMinimumField.text != "") {
            guidelines.append(
                DietaryManagement(
                    id : 0,
                    description : "",
                    amount : Int(grainMinimumField.text!)!,
                    isActive : true,
                    patientId : 0
                )
            )
        }
    }
    
    func addMaxiumumGrainGuideline() {
        if(grainMaximumField.text != "") {
            guidelines.append(
                DietaryManagement(
                    id : 0,
                    description : "",
                    amount : Int(grainMaximumField.text!)!,
                    isActive : true,
                    patientId : 0
                )
            )
        }
    }
}
