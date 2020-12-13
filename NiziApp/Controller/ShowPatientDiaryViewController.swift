//
//  ShowPatientDiaryViewController.swift
//  NiziApp
//
//  Created by Patrick Dammers on 11/12/2020.
//  Copyright © 2020 Samir Yeasin. All rights reserved.
//

import Foundation
import UIKit
import SwiftKeychainWrapper

class ShowPatientDiaryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var heightHeader : CGFloat = 44
    
    @IBOutlet weak var diaryTable: UITableView!
    @IBOutlet weak var DatePicker: UIDatePicker!

    var consumptions   : [NewConsumption] = []
    var breakfastFoods : [NewConsumption] = []
    var lunchFoods     : [NewConsumption] = []
    var dinnerFoods    : [NewConsumption] = []
    var snackFoods     : [NewConsumption] = []
    var headers        : [postStruct] = []
    var patient        : NewPatient?
    @IBOutlet weak var calendar: UIDatePicker!
    
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Diary" ,comment: "")
        headers = [postStruct.init(image: #imageLiteral(resourceName: "Sunrise_s"), text: "Ontbijt"),postStruct.init(image: #imageLiteral(resourceName: "Sun"), text: "Lunch"),postStruct.init(image: #imageLiteral(resourceName: "Sunset"), text: "Avond"),postStruct.init(image: #imageLiteral(resourceName: "Food"), text: "Snack")]

        let finalDate = dateFormatter.string(from: Date()) + "T00:00:00.000Z"
        
        saveDate(date: finalDate)
        getConsumption(Date:KeychainWrapper.standard.string(forKey: "date")!)
        
        calendar.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
    }
    
    @objc func datePickerChanged(picker: UIDatePicker) {

        let selectedDate: String = dateFormatter.string(from: picker.date)
        
        getConsumption(Date: selectedDate)
        saveDate(date: selectedDate)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        var date = Date()
        let formattedDate = dateFormatter.string(from: date)
        let finalDate = formattedDate + "T00:00:00.000Z"
        getConsumption(Date: finalDate)
        calendar.setDate(date, animated: false)
    }
    
    fileprivate func SetupDatePicker() {
        DatePicker.setValue(UIColor.white, forKeyPath: "textColor")
        DatePicker.setValue(false, forKeyPath: "highlightsToday")
        //DatePicker.backgroundColor = UIColor(red: 0x0A, green: 0x71, blue: 0xCB)
        DatePicker.addTarget(self, action: #selector(DiaryViewController.datePickerValueChanged(_:)), for: .valueChanged)
    }
    
    func SortFood(){
        for food in consumptions {
            switch food.mealTime {
            case "Ontbijt":
                breakfastFoods.append(food)
                break
            case "Lunch":
                lunchFoods.append(food)
                break
            case "Avondeten":
                dinnerFoods.append(food)
                break
            case "Snack":
                snackFoods.append(food)
            default:
                print("no valid food")
                break
            }
        }
        
    }
    
    func createNewPatientObject(id: Int, gender: String, dateOfBirth: String, createdAt: String, updatedAt: String, doctor: Int, user: Int) -> NewPatient {
        
        let patient : NewPatient = NewPatient(id: id, gender: gender, dateOfBirth: dateOfBirth, createdAt: createdAt, updatedAt: updatedAt, doctor: doctor, user: user)
        return patient
    }
    
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        
        // Apply date format
        let selectedDate: String = dateFormatter.string(from: sender.date)
        
        getConsumption(Date: selectedDate)
        saveDate(date: selectedDate)
    }
    
    // API Calls
    func getConsumption(Date date: String) {
        breakfastFoods  = []
        lunchFoods      = []
        dinnerFoods     = []
        snackFoods      = []
        NiZiAPIHelper.readAllConsumption(withToken: KeychainWrapper.standard.string(forKey: "authToken")!, withPatient: 1, withStartDate: date).responseData(completionHandler: { response in
            
            guard let jsonResponse = response.data
            else { return }
            
            let jsonDecoder = JSONDecoder()
            guard let consumptionlist = try? jsonDecoder.decode( [NewConsumption].self, from: jsonResponse )
                else { return }
            
            self.consumptions = consumptionlist
            self.SortFood()
            self.diaryTable?.reloadData()
        })
    }
    
    func saveDate(date: String) {
        KeychainWrapper.standard.set(date, forKey: "date")
    }
    
    //MARK: Table Functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return breakfastFoods.count
        case 1:
            return lunchFoods.count
        case 2:
            return dinnerFoods.count
        case 3:
            return snackFoods.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
     switch section {
     case 0:
     return NSLocalizedString("Breakfast", comment: "Category")
     case 1:
     return NSLocalizedString("Lunch", comment: "Category")
     case 2:
     return NSLocalizedString("Dinner", comment: "Category")
     case 3:
     return NSLocalizedString("Snacks", comment: "Category")
     default:
     return ""
     }
     }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "diarytablecell", for: indexPath) as! DiaryTableViewCell
        
        var navigationTitle = ""
        var amountText = ""
        var portionSize = ""
        var portion : Float = 0.0
        
        
        switch indexPath.section {
        case 0:
            navigationTitle = (breakfastFoods[indexPath.row].foodMealCompenent?.name)!
            amountText = (breakfastFoods[indexPath.row].amount?.description)!
            portion = (breakfastFoods[indexPath.row].amount)! * (breakfastFoods[indexPath.row].foodMealCompenent?.portionSize)!
            portionSize = portion.description + " " + breakfastFoods[indexPath.row].weightUnit!.short
            
            break
        case 1:
            navigationTitle = (lunchFoods[indexPath.row].foodMealCompenent?.name)!
            amountText = (lunchFoods[indexPath.row].amount?.description)!
            portion = (lunchFoods[indexPath.row].amount)! * (lunchFoods[indexPath.row].foodMealCompenent?.portionSize)!
            portionSize = portion.description + " " + lunchFoods[indexPath.row].weightUnit!.short
            break
        case 2:
            navigationTitle = (dinnerFoods[indexPath.row].foodMealCompenent?.name)!
            amountText = (dinnerFoods[indexPath.row].amount?.description)!
            portion = (breakfastFoods[indexPath.row].amount)! * (breakfastFoods[indexPath.row].foodMealCompenent?.portionSize)!
            portionSize = portion.description + " " + breakfastFoods[indexPath.row].weightUnit!.short
            break
        case 3:
            navigationTitle = (snackFoods[indexPath.row].foodMealCompenent?.name)!
            amountText = (snackFoods[indexPath.row].amount?.description)!
            portion = (breakfastFoods[indexPath.row].amount)! * (breakfastFoods[indexPath.row].foodMealCompenent?.portionSize)!
            portionSize = portion.description + " " + breakfastFoods[indexPath.row].weightUnit!.short
            break
        default:
            break
        }
        cell.productTitle?.text = navigationTitle
        cell.amountLbl.text = amountText
        cell.portionLbl.text = portionSize
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0;
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)?.first as! HeaderView
        
        headerView.headerImageView.image = headers[section].image
        headerView.headerLabel.text = headers[section].text
        headerView.AddButton.tag = section
        headerView.GotoDiary(){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let detailFoodVC = storyboard.instantiateViewController(withIdentifier:"ProductListViewController") as! SearchFoodViewController;()
            detailFoodVC.buttonTag = section
            self.navigationController?.pushViewController(detailFoodVC, animated: true)
        
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return heightHeader
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
    
    @IBAction func previousDay(_ sender: Any) {
        calendar.date.addTimeInterval(-86400)

        let finalDate = dateFormatter.string(from: calendar.date) + "T00:00:00.000Z"
        getConsumption(Date: finalDate)
    }
    
    @IBAction func nextDay(_ sender: Any) {
        calendar.date.addTimeInterval(86400)
        
        let finalDate = dateFormatter.string(from: calendar.date) + "T00:00:00.000Z"
        getConsumption(Date: finalDate)
    }
    
}
