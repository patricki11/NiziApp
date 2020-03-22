//
//  AddPatientGuidelinesViewController.swift
//  NiziApp
//
//  Created by Samir Yeasin on 20/03/2020.
//  Copyright © 2020 Samir Yeasin. All rights reserved.
//

import Foundation
import UIKit
import SwiftKeychainWrapper

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
    
    let onlyAllowNumbersDelegate = OnlyAllowNumbersDelegate()
    
    weak var patient : Patient!
    
    var guidelines : [DietaryManagement] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setLanguageSpecificText()
        setNumericOnlyFields()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setNumericOnlyFields()
    }
    
    func setNumericOnlyFields() {
        
        caloriesMinimumField.delegate = onlyAllowNumbersDelegate
        caloriesMaximumField.delegate = onlyAllowNumbersDelegate
        waterMinimumField.delegate = onlyAllowNumbersDelegate
        waterMaximumField.delegate = onlyAllowNumbersDelegate
        sodiumMinimumField.delegate = onlyAllowNumbersDelegate
        sodiumMaximumField.delegate = onlyAllowNumbersDelegate
        potassiumMinimumField.delegate = onlyAllowNumbersDelegate
        potassiumMaximumField.delegate = onlyAllowNumbersDelegate
        proteinMinimumFIeld.delegate = onlyAllowNumbersDelegate
        proteinMaximumField.delegate = onlyAllowNumbersDelegate
        grainMinimumField.delegate = onlyAllowNumbersDelegate
        grainMaximumField.delegate = onlyAllowNumbersDelegate
    }
    
    func setLanguageSpecificText() {
        caloriesTitle.text = NSLocalizedString("caloriesTitle", comment: "")
        waterTitle.text = NSLocalizedString("waterTitle", comment: "")
        sodiumTitle.text = NSLocalizedString("sodiumTitle", comment: "")
        potassiumTitle.text = NSLocalizedString("potassiumTItle", comment: "")
        proteinTitle.text = NSLocalizedString("proteinTitle", comment: "")
        grainTitle.text = NSLocalizedString("grainTitle", comment: "")
        
        caloriesMinimumTitle.text = NSLocalizedString("Minimum", comment: "")
        waterMinimumTitle.text = NSLocalizedString("Minimum", comment: "")
        sodiumMinimumTitle.text = NSLocalizedString("Minimum", comment: "")
        potassiumMinimumTitle.text = NSLocalizedString("Minimum", comment: "")
        proteinMinimumTitle.text = NSLocalizedString("Minimum", comment: "")
        grainMinimumTitle.text = NSLocalizedString("Minimum", comment: "")
        
        caloriesMaximumTitle.text = NSLocalizedString("Maximum", comment: "")
        waterMaximumTitle.text = NSLocalizedString("Maximum", comment: "")
        sodiumMaximumTitle.text = NSLocalizedString("Maximum", comment: "")
        potassiumMaximumTitle.text = NSLocalizedString("Maximum", comment: "")
        proteinMaximumTitle.text = NSLocalizedString("Maximum", comment: "")
        grainMaximumTitle.text = NSLocalizedString("Maximum", comment: "")
    }
    
    @IBAction func savePatientGuidelines(_ sender: Any) {
        getGuidelines()
        
        for guideline in guidelines {
            NiZiAPIHelper.createDietaryManagement(forPatient: guideline.patientId, withGuideline: guideline, authenticationCode: KeychainWrapper.standard.string(forKey: "authToken")!)
        }
        
        showGuidelinesAddedMessage()
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
                    description : "Calorieverrijking",
                    amount : Int(caloriesMinimumField.text!)!,
                    isActive : true,
                    patientId : patient.patientId!
                )
            )
        }
    }
    
    func addMaximumCaloriesGuideline() {
        if(caloriesMaximumField.text != "") {
            guidelines.append(
                DietaryManagement(
                    id : 0,
                    description : "Caloriebeperking",
                    amount : Int(caloriesMaximumField.text!)!,
                    isActive : true,
                    patientId : patient.patientId!
                )
            )
        }
    }
    
    func addMinimumWaterGuideilne() {
        if(waterMinimumField.text != "") {
            guidelines.append(
                DietaryManagement(
                    id : 0,
                    description : "Vochtverrijking",
                    amount : Int(waterMinimumField.text!)!,
                    isActive : true,
                    patientId : patient.patientId!
                )
            )
        }
    }
    
    func addMaximumWaterGuideline() {
        if(waterMaximumField.text != "") {
            guidelines.append(
                DietaryManagement(
                    id : 0,
                    description : "Vochtbeperking",
                    amount : Int(waterMaximumField.text!)!,
                    isActive : true,
                    patientId : patient.patientId!
                )
            )
        }
    }
    
    func addMinimumSodiumGuideline() {
        if(sodiumMinimumField.text != "") {
            guidelines.append(
                DietaryManagement(
                    id : 0,
                    description : "Natriumverrijking",
                    amount : Int(sodiumMinimumField.text!)!,
                    isActive : true,
                    patientId : patient.patientId!
                )
            )
        }
    }
    
    func addMaximumSodiumGuideline() {
        if(sodiumMaximumField.text != "") {
            guidelines.append(
                DietaryManagement(
                    id : 0,
                    description : "Natriumbeperking",
                    amount : Int(sodiumMaximumField.text!)!,
                    isActive : true,
                    patientId : patient.patientId!
                )
            )
        }
    }
    
    func addMinimumPotassiumGuideline() {
        if(potassiumMinimumField.text != "") {
            guidelines.append(
                DietaryManagement(
                    id : 0,
                    description : "Kaliumverrijking",
                    amount : Int(potassiumMinimumField.text!)!,
                    isActive : true,
                    patientId : patient.patientId!
                )
            )
        }
    }
    
    func addMaximumPotassiumGuideline() {
        if(potassiumMaximumField.text != "") {
            guidelines.append(
                DietaryManagement(
                    id : 0,
                    description : "Kaliumbeperking",
                    amount : Int(potassiumMaximumField.text!)!,
                    isActive : true,
                    patientId : patient.patientId!
                )
            )
        }
    }
    
    func addMinimumProteinGuideline() {
        if(proteinMinimumFIeld.text != "") {
            guidelines.append(
                DietaryManagement(
                    id : 0,
                    description : "Eiwitverrijking",
                    amount : Int(proteinMinimumFIeld.text!)!,
                    isActive : true,
                    patientId : patient.patientId!
                )
            )
        }
    }
    
    func addMaximumProteinGuideline() {
        if(proteinMaximumField.text != "") {
            guidelines.append(
                DietaryManagement(
                    id : 0,
                    description : "Eiwitbeperking",
                    amount : Int(proteinMaximumField.text!)!,
                    isActive : true,
                    patientId : patient.patientId!
                )
            )
        }
    }
    
    func addMinimumGrainGuideline() {
        if(grainMinimumField.text != "") {
            guidelines.append(
                DietaryManagement(
                    id : 0,
                    description : "Vezelverrijking",
                    amount : Int(grainMinimumField.text!)!,
                    isActive : true,
                    patientId : patient.patientId!
                )
            )
        }
    }
    
    func addMaxiumumGrainGuideline() {
        if(grainMaximumField.text != "") {
            guidelines.append(
                DietaryManagement(
                    id : 0,
                    description : "Vezelbeperking",
                    amount : Int(grainMaximumField.text!)!,
                    isActive : true,
                    patientId : patient.patientId!
                )
            )
        }
    }
    
    func showGuidelinesAddedMessage() {
        let alertController = UIAlertController(
            title: "Patiënt toegevoegd",
            message: "De patiënt is toegevoegd.",
            preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "Ok"), style: .default, handler: { _ in self.navigateBackToPatientList()}))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func navigateBackToPatientList() {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
    }
}
