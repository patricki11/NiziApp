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
    
    var newPatient : NewPatient!
    var newUser : NewUser!
    
    var guidelines : [NewDietaryManagement] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("AddPatient", comment: "")
        setLanguageSpecificText()
        setNumericOnlyFields()
        removeKeyboardAfterClickingOutsideField()
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
        potassiumTitle.text = NSLocalizedString("potassiumTitle", comment: "")
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
        
        savePatientButton.setTitle(NSLocalizedString("createPatient", comment: ""), for: .normal)
    }
    
    @IBAction func savePatientGuidelines(_ sender: Any) {
        addNewPatient()
    }
    
    func getGuidelines() {
        addCaloriesGuideline()
        addWaterGuideline()
        addSodiumGuideline()
        addPotassiumGuideline()
        addProteinGuideline()
        addfiberGuideline()
    }
    
    func addCaloriesGuideline() {
        var minimum : Int? = nil
        var maximum : Int? = nil
        
        if(caloriesMinimumField.text != nil) {
            minimum = Int(caloriesMinimumField.text!)
        }
        if(caloriesMaximumField.text != nil) {
            maximum = Int(caloriesMaximumField.text!)
        }
        
        if(minimum == nil && maximum == nil) {
            return
        }

        guidelines.append(
            NewDietaryManagement(
                id: 0,
                isActive: true,
                dietaryRestriction: 1,
                patient: newPatient.id,
                createdAt: nil,
                updatedAt: nil,
                minimum: minimum,
                maximum: maximum
            )
        )
    }
    
    func addWaterGuideline() {
        var minimum : Int? = nil
        var maximum : Int? = nil
        
        if(waterMinimumField.text != nil) {
            minimum = Int(waterMinimumField.text!)
        }
        if(waterMaximumField.text != nil) {
            maximum = Int(waterMaximumField.text!)
        }

        if(minimum == nil && maximum == nil) {
            return
        }
        
        guidelines.append(
            NewDietaryManagement(
                id: 0,
                isActive: true,
                dietaryRestriction: 2,
                patient: newPatient.id,
                createdAt: nil,
                updatedAt: nil,
                minimum: minimum,
                maximum: maximum
            )
        )
    }
    
    func addSodiumGuideline() {
        var minimum : Int? = nil
        var maximum : Int? = nil
        
        if(sodiumMinimumField.text != nil) {
            minimum = Int(sodiumMinimumField.text!)
        }
        if(sodiumMaximumField.text != nil) {
            maximum = Int(sodiumMaximumField.text!)
        }
        
        if(minimum == nil && maximum == nil) {
            return
        }

        guidelines.append(
            NewDietaryManagement(
                id: 0,
                isActive: true,
                dietaryRestriction: 3,
                patient: newPatient.id,
                createdAt: nil,
                updatedAt: nil,
                minimum: minimum,
                maximum: maximum
            )
        )
    }
    
    func addPotassiumGuideline() {
        var minimum : Int? = nil
        var maximum : Int? = nil
        
        if(potassiumMinimumField.text != nil) {
            minimum = Int(potassiumMinimumField.text!)
        }
        if(potassiumMaximumField.text != nil) {
            maximum = Int(potassiumMaximumField.text!)
        }

        if(minimum == nil && maximum == nil) {
            return
        }
        
        guidelines.append(
            NewDietaryManagement(
                id: 0,
                isActive: true,
                dietaryRestriction: 4,
                patient: newPatient.id,
                createdAt: nil,
                updatedAt: nil,
                minimum: minimum,
                maximum: maximum
            )
        )
    }
    
    func addProteinGuideline() {
        var minimum : Int? = nil
        var maximum : Int? = nil
        
        if(proteinMinimumFIeld.text != nil) {
            minimum = Int(proteinMinimumFIeld.text!)
        }
        if(proteinMaximumField.text != nil) {
            maximum = Int(proteinMaximumField.text!)
        }
        
        if(minimum == nil && maximum == nil) {
            return
        }

        guidelines.append(
            NewDietaryManagement(
                id: 0,
                isActive: true,
                dietaryRestriction: 5,
                patient: newPatient.id,
                createdAt: nil,
                updatedAt: nil,
                minimum: minimum,
                maximum: maximum
            )
        )
    }
    
    func addfiberGuideline() {
        var minimum : Int? = nil
        var maximum : Int? = nil
        
        if(grainMinimumField.text != nil) {
            minimum = Int(grainMinimumField.text!)
        }
        if(grainMaximumField.text != nil) {
            maximum = Int(grainMaximumField.text!)
        }
        
        if(minimum == nil && maximum == nil) {
            return
        }

        guidelines.append(
            NewDietaryManagement(
                id: 0,
                isActive: true,
                dietaryRestriction: 6,
                patient: newPatient.id,
                createdAt: nil,
                updatedAt: nil,
                minimum: minimum,
                maximum: maximum
            )
        )
    }
    
    func addNewPatient() {
        NiZiAPIHelper.addPatient(withDetails: newPatient, authenticationCode: KeychainWrapper.standard.string(forKey: "authToken")!).responseData(completionHandler: { response in
            guard let jsonResponse = response.data else { return }
            
            let jsonDecoder = JSONDecoder()
            guard let patient = try? jsonDecoder.decode(NewPatient.self, from: jsonResponse) else { return }
            
            self.newPatient = patient
            self.newUser.patient = patient.id!
            self.addNewAccount()
        })
    }
    
    func addNewAccount() {
        NiZiAPIHelper.addUser(withDetails: newUser, authenticationCode: KeychainWrapper.standard.string(forKey: "authToken")!).responseData(completionHandler: { response in
            guard let jsonResponse = response.data else { return }
            
            let jsonDecoder = JSONDecoder()
            guard let patientUser = try? jsonDecoder.decode(NewUser.self, from: jsonResponse) else { return }
            
            self.newUser = patientUser
            
            self.addNewGuidelines()
        })
    }
    
    func addNewGuidelines() {
        getGuidelines()
        var completedGuidelines = 0
        
        for guideline in guidelines {
            NiZiAPIHelper.createDietaryManagement(forPatient: newPatient.id!, withGuideline: guideline, authenticationCode: KeychainWrapper.standard.string(forKey: "authToken")!).responseData(completionHandler: { _ in
                
                completedGuidelines += 1
                
                if(self.guidelines.count == completedGuidelines) {
                    self.showPatientAddedMessage()
                }
            })
        }
        
        if(guidelines.count == 0) {
            self.showPatientAddedMessage()
        }
    }
    
    func showGuidelinesAddedMessage() {
        let alertController = UIAlertController(
            title: NSLocalizedString("guidelinesAddedTitle", comment: ""),
            message: NSLocalizedString("guidelinesAddedMessage", comment: ""),
            preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "Ok"), style: .default, handler: { _ in self.navigateBackToPatientList()}))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showPatientAddedMessage() {
        let alertController = UIAlertController(
            title: NSLocalizedString("patientAddedTitle", comment: ""),
            message: NSLocalizedString("patientAddedMessage", comment: ""),
            preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "Ok"), style: .default, handler: { _ in self.navigateBackToPatientList()}))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func navigateBackToPatientList() {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
    }
}
