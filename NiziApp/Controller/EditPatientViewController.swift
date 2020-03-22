//
//  EditPatientViewController.swift
//  NiziApp
//
//  Created by Samir Yeasin on 05/01/2020.
//  Copyright © 2020 Samir Yeasin. All rights reserved.
//

import Foundation
import UIKit
import SwiftKeychainWrapper

class EditPatientViewController : UIViewController {
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var surnameLabel: UILabel!
    @IBOutlet weak var dateOfBirthLabel: UILabel!
    
    @IBOutlet weak var personalInfoLabel: UILabel!
    @IBOutlet weak var guidelineInfoLabel: UILabel!
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var surnameField: UITextField!
    @IBOutlet weak var dateOfBirthField: UITextField!
    
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
    
    @IBOutlet weak var editPatientButton: UIButton!
    
    var patientGuidelines : [DietaryManagement] = []
    var newGuidelines : [DietaryManagement] = []
    
    var completedDeleting : [DietaryManagement] = []
    var completedUpdating : [DietaryManagement] = []
    
    var restrictions : [Restrictions] = []
    var onlyAllowNumbersDelegate = OnlyAllowNumbersDelegate()

    var activeTextField : UITextField = UITextField()
    
    var patientInfo : PatientPersonalInfo? = nil
    var patientId : Int!
    
    func datePicker() -> UIDatePicker {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.addTarget(self, action: #selector(datePickerChanged(_:)), for: .valueChanged)
        picker.maximumDate = Date()
        return picker
    }
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-YYYY"
        return formatter
    }()
    
    @objc func datePickerChanged(_ sender: UIDatePicker) {
        dateOfBirthField.text = dateFormatter.string(from: sender.date)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Bewerken Patiënt"
        dateOfBirthField.inputView = datePicker()
        getPatientObject()
        setLanguageSpecificText()
        getPatientGuidelines()
        setNumbersOnlyDelegate()
    }
    
    func setNumbersOnlyDelegate() {
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
    
    func setPatientGuidelines() {
        for guideline in patientGuidelines {
            switch guideline.description {
            case "Calorieverrijking":
                setGuidelineFields(guideline: guideline, field: caloriesMinimumField)
                break
            case "Caloriebeperking":
                setGuidelineFields(guideline: guideline, field: caloriesMaximumField)
                break
            case "Vochtverrijking":
                setGuidelineFields(guideline: guideline, field: waterMinimumField)
                break
            case "Vochtbeperking":
                setGuidelineFields(guideline: guideline, field: waterMaximumField)
                break
            case "Natriumverrijking":
                setGuidelineFields(guideline: guideline, field: sodiumMinimumField)
                break
            case "Natriumbeperking":
                setGuidelineFields(guideline: guideline, field: sodiumMaximumField)
                break
            case "Kaliumverrijking":
                setGuidelineFields(guideline: guideline, field: potassiumMinimumField)
                break
            case "Kaliumbeperking":
                setGuidelineFields(guideline: guideline, field: potassiumMaximumField)
                break
            case "Eiwitverrijking":
                setGuidelineFields(guideline: guideline, field: proteinMinimumFIeld)
                break
            case "Eiwitbeperking":
                setGuidelineFields(guideline: guideline, field: proteinMaximumField)
                break
            case "Vezelverrijking":
                setGuidelineFields(guideline: guideline, field: grainMinimumField)
                break
            case "Vezelbeperking":
                setGuidelineFields(guideline: guideline, field: grainMaximumField)
                break
            default:
                break
            }
        }
    }
    
    func setGuidelineFields(guideline: DietaryManagement, field: UITextField) {
        field.text = String(guideline.amount)
    }
    
    func fillFieldsWithPatientInfo() {
        firstNameField.text = patientInfo?.firstName
        surnameField.text = patientInfo?.lastName
        
        let dateFormatterFrom = DateFormatter()
        dateFormatterFrom.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let dateFormatterTo = DateFormatter()
        dateFormatterTo.dateFormat = "dd-MM-YYYY"
        
        let date : Date = dateFormatterFrom.date(from: patientInfo?.dateOfBirth ?? "") ?? Date()
        
        dateOfBirthField.text = dateFormatterTo.string(from: date)
    }
    
    func setLanguageSpecificText() {
        firstNameLabel.text = NSLocalizedString("firstName", comment: "")
        surnameLabel.text = NSLocalizedString("surname", comment: "")
        dateOfBirthLabel.text = NSLocalizedString("dateOfBirth", comment: "")
        personalInfoLabel.text = NSLocalizedString("personalInfo", comment: "")
        editPatientButton.setTitle(NSLocalizedString("editPatient", comment: ""), for: .normal)
        
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
        
        // TODO: Localizable Strings
        guidelineInfoLabel.text = "Richtlijnen"
    }
    
    
    @IBAction func confirmEdit(_ sender: Any) {
        if(allRequiredFieldsFilled()) {
            updateGuidelines()
            // TODO: Update patientgegevens, nog geen call voor in API >.>
        }
        else {
            print("notFilled")
        }
    }
    
    func updateGuidelines() {
        getNewGuidelines()
        deleteOldGuidelines()
        createNewGuidelines()
    }
    
    func deleteOldGuidelines() {
        for guideline in patientGuidelines {
            guideline.isActive = false
            NiZiAPIHelper.deleteDietaryManagement(forDiet: guideline.id, authenticationCode: KeychainWrapper.standard.string(forKey: "authToken")!).responseData(completionHandler: { response in
                self.completedDeleting.append(guideline)
                
                if(self.completedAllRequests()) {
                    self.showUpdatedMessage()
                }
            })
        }
    }
    
    func createNewGuidelines() {
        for guideline in newGuidelines {
            NiZiAPIHelper.createDietaryManagement(forPatient: patientId, withGuideline: guideline, authenticationCode: KeychainWrapper.standard.string(forKey: "authToken")!).responseJSON(completionHandler: { response in

                self.completedUpdating.append(guideline)
                
                if(self.completedAllRequests()) {
                    self.showUpdatedMessage()
                }
            })
        }
    }
    
    func completedAllRequests() -> Bool {
        if(completedUpdating.count == self.newGuidelines.count && completedDeleting.count == self.patientGuidelines.count) {
            return true
        }
        else {
            return false
        }
    }
    
    func getPatientGuidelines() {
        NiZiAPIHelper.getDietaryManagement(forDiet: patientId, authenticationCode: KeychainWrapper.standard.string(forKey: "authToken")!).response(completionHandler: {response in
            
            guard let jsonResponse = response.data else { return }

            let jsonDecoder = JSONDecoder()
            
            guard let guidelines = try? jsonDecoder.decode(PatientDietaryGuidelines.self, from: jsonResponse) else { return }
            
            self.patientGuidelines = guidelines.dietaryManagements
            self.setPatientGuidelines()
        })
    }
    
    func getNewGuidelines() {
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
            newGuidelines.append(
                DietaryManagement(
                    id : 0,
                    description : "Calorieverrijking",
                    amount : Int(caloriesMinimumField.text!)!,
                    isActive : true,
                    patientId : patientId
                )
            )
        }
    }
    
    func addMaximumCaloriesGuideline() {
        if(caloriesMaximumField.text != "") {
            newGuidelines.append(
                DietaryManagement(
                    id : 0,
                    description : "Caloriebeperking",
                    amount : Int(caloriesMaximumField.text!)!,
                    isActive : true,
                    patientId : patientId
                )
            )
        }
    }
    
    func addMinimumWaterGuideilne() {
        if(waterMinimumField.text != "") {
            newGuidelines.append(
                DietaryManagement(
                    id : 0,
                    description : "Vochtverrijking",
                    amount : Int(waterMinimumField.text!)!,
                    isActive : true,
                    patientId : patientId
                )
            )
        }
    }
    
    func addMaximumWaterGuideline() {
        if(waterMaximumField.text != "") {
            newGuidelines.append(
                DietaryManagement(
                    id : 0,
                    description : "Vochtbeperking",
                    amount : Int(waterMaximumField.text!)!,
                    isActive : true,
                    patientId : patientId
                )
            )
        }
    }
    
    func addMinimumSodiumGuideline() {
        if(sodiumMinimumField.text != "") {
            newGuidelines.append(
                DietaryManagement(
                    id : 0,
                    description : "Natriumverrijking",
                    amount : Int(sodiumMinimumField.text!)!,
                    isActive : true,
                    patientId : patientId
                )
            )
        }
    }
    
    func addMaximumSodiumGuideline() {
        if(sodiumMaximumField.text != "") {
            newGuidelines.append(
                DietaryManagement(
                    id : 0,
                    description : "Natriumbeperking",
                    amount : Int(sodiumMaximumField.text!)!,
                    isActive : true,
                    patientId : patientId
                )
            )
        }
    }
    
    func addMinimumPotassiumGuideline() {
        if(potassiumMinimumField.text != "") {
            newGuidelines.append(
                DietaryManagement(
                    id : 0,
                    description : "Kaliumverrijking",
                    amount : Int(potassiumMinimumField.text!)!,
                    isActive : true,
                    patientId : patientId
                )
            )
        }
    }
    
    func addMaximumPotassiumGuideline() {
        if(potassiumMaximumField.text != "") {
            newGuidelines.append(
                DietaryManagement(
                    id : 0,
                    description : "Kaliumbeperking",
                    amount : Int(potassiumMaximumField.text!)!,
                    isActive : true,
                    patientId : patientId
                )
            )
        }
    }
    
    func addMinimumProteinGuideline() {
        if(proteinMinimumFIeld.text != "") {
            newGuidelines.append(
                DietaryManagement(
                    id : 0,
                    description : "Eiwitverrijking",
                    amount : Int(proteinMinimumFIeld.text!)!,
                    isActive : true,
                    patientId : patientId
                )
            )
        }
    }
    
    func addMaximumProteinGuideline() {
        if(proteinMaximumField.text != "") {
            newGuidelines.append(
                DietaryManagement(
                    id : 0,
                    description : "Eiwitbeperking",
                    amount : Int(proteinMaximumField.text!)!,
                    isActive : true,
                    patientId : patientId
                )
            )
        }
    }
    
    func addMinimumGrainGuideline() {
        if(grainMinimumField.text != "") {
            newGuidelines.append(
                DietaryManagement(
                    id : 0,
                    description : "Vezelverrijking",
                    amount : Int(grainMinimumField.text!)!,
                    isActive : true,
                    patientId : patientId
                )
            )
        }
    }
    
    func addMaxiumumGrainGuideline() {
        if(grainMaximumField.text != "") {
            newGuidelines.append(
                DietaryManagement(
                    id : 0,
                    description : "Vezelbeperking",
                    amount : Int(grainMaximumField.text!)!,
                    isActive : true,
                    patientId : patientId
                )
            )
        }
    }
    
    func getPatientObject() {
        NiZiAPIHelper.getPatient(byId: patientId, authenticationCode: KeychainWrapper.standard.string(forKey: "authToken")!).response(completionHandler: { response in
            guard let jsonResponse = response.data else { return }
            let jsonDecoder = JSONDecoder()
            
            guard let personalInfo = try? jsonDecoder.decode(PatientPersonalInfo.self, from: jsonResponse) else { return }
            
            self.patientInfo = personalInfo
            self.fillFieldsWithPatientInfo()
            
        })
    }
    
    func allRequiredFieldsFilled() -> Bool {
        let firstName = firstNameField.text
        let surname = surnameField.text
        let dateOfBirth = dateOfBirthField.text
        
        return (firstName != "" && surname != "" && dateOfBirth != "")
    }
    
    func updateNewPatientObject() {
        patientInfo?.firstName = ""
        patientInfo?.lastName = ""
    }
    
    func showUpdatedMessage() {
        let alertController = UIAlertController(
            title: "Patiënt bijgewerkt",
            message: "De patiëntgegevens zijn bijgewerkt.",
            preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "Ok"), style: .default, handler: { _ in self.navigateBackToPatientOverview()}))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func navigateBackToPatientOverview() {
        self.navigationController!.popViewController(animated: true)
    }
}

class OnlyAllowNumbersDelegate : UIViewController, UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string.count == 0 {
            return true
        }
        
        if let x = string.rangeOfCharacter(from: NSCharacterSet.decimalDigits) {
          return true
       } else {
          return false
       }
    }
}
