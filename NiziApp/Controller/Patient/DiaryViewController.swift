//
//  DiaryViewController.swift
//  NiziApp
//
//  Created by Samir Yeasin on 23/03/2020.
//  Copyright © 2020 Samir Yeasin. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

struct postStruct {
    var image : UIImage!
    var text: String!
}

class DiaryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var heightHeader : CGFloat = 44
    
    @IBOutlet weak var diaryTable: UITableView!
    @IBOutlet weak var DatePicker: UIDatePicker!
    //let patientIntID    : Int? = Int(KeychainWrapper.standard.string(forKey: "patientId")!)
    var consumptions   : [NewConsumption] = []
    var breakfastFoods : [NewConsumption] = []
    var lunchFoods     : [NewConsumption] = []
    var dinnerFoods    : [NewConsumption] = []
    var snackFoods     : [NewConsumption] = []
    var headers        : [postStruct] = []
    var patient        : NewPatient?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.patient = createNewPatientObject(id: 1, gender: "Male", dateOfBirth: "1995-02-08", createdAt: "2020-10-07T11:49:26.000Z", updatedAt: "2020-10-07T12:04:08.000Z", doctor: 1, user: 1)
        headers = [postStruct.init(image: #imageLiteral(resourceName: "Sunrise_s"), text: "Ontbijt"),postStruct.init(image: #imageLiteral(resourceName: "Sun"), text: "Lunch"),postStruct.init(image: #imageLiteral(resourceName: "Sunset"), text: "Avond"),postStruct.init(image: #imageLiteral(resourceName: "Food"), text: "Snack")]
        print("Boogie ",self.patient?.id)
        //print(KeychainWrapper.standard.string(forKey: "patientId"))
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let formattedDate = format.string(from: date)
        saveDate(date: formattedDate)
        getConsumption(Date: "2020-11-18T00:00:00.000Z")
        //SetupDatePicker()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getConsumption(Date: "2020-11-18T00:00:00.000Z")
    }
    
    fileprivate func SetupDatePicker() {
        DatePicker.setValue(UIColor.white, forKeyPath: "textColor")
        DatePicker.setValue(false, forKeyPath: "highlightsToday")
        DatePicker.backgroundColor = UIColor(red: 0x0A, green: 0x71, blue: 0xCB)
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
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        
        // Create date formatter
        let dateFormatter: DateFormatter = DateFormatter()
        
        // Set date format
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // Apply date format
        let selectedDate: String = dateFormatter.string(from: sender.date)
        
        getConsumption(Date: selectedDate)
        saveDate(date: selectedDate)
        //-----------------------------
        //print("Selected value \(selectedDate)")
    }
    
    // API Calls
    func getConsumption(Date date: String) {
        breakfastFoods  = []
        lunchFoods      = []
        dinnerFoods     = []
        snackFoods      = []
        NiZiAPIHelper.readAllConsumption(withToken: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiaWF0IjoxNjA1MTA0Njk3LCJleHAiOjE2MDc2OTY2OTd9.VQqpsXC4IrdPjcNE9cuMpwumiLncAKorGB8eIDAWS2Y", withPatient: 1, withStartDate: date).responseData(completionHandler: { response in
            
            guard let jsonResponse = response.data
                else { print("temp1"); return }
            
            let jsonDecoder = JSONDecoder()
            guard let consumptionlist = try? jsonDecoder.decode( [NewConsumption].self, from: jsonResponse )
                else { print("temp2"); return }
            
            self.consumptions = consumptionlist
            self.SortFood()
            self.diaryTable?.reloadData()
        })
    }
    
    func Deleteconsumption(Id id: Int){
        NiZiAPIHelper.deleteConsumption(withId: id, authenticationCode: KeychainWrapper.standard.string(forKey: "authToken")!).responseData(completionHandler: { response in
            guard response.data != nil
                else { print("temp1"); return }
        })
        //self.getConsumption(Date: KeychainWrapper.standard.string(forKey: "date")!)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "diarytablecell", for: indexPath)
        
        var navigationTitle = ""
        
        switch indexPath.section {
        case 0:
            navigationTitle = (breakfastFoods[indexPath.row].foodMealCompenent?.name)!
            break
        case 1:
            navigationTitle = (lunchFoods[indexPath.row].foodMealCompenent?.name)!
            break
        case 2:
            navigationTitle = (dinnerFoods[indexPath.row].foodMealCompenent?.name)!
            break
        case 3:
            navigationTitle = (snackFoods[indexPath.row].foodMealCompenent?.name)!
            break
        default:
            break
        }
        cell.textLabel?.text = navigationTitle
        cell.accessoryType = .detailButton
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.Deleteconsumption(Id: consumptions[indexPath.row].id!)
            var consumption : NewConsumption = consumptions[indexPath.row]
            switch consumption.mealTime {
            case "Ontbijt":
                self.breakfastFoods.remove(at: indexPath.row)
                break
            case "Lunch":
                self.breakfastFoods.remove(at: indexPath.row)
                break
            case "AvondEten":
                self.breakfastFoods.remove(at: indexPath.row)
                break
            case "Snack":
                self.breakfastFoods.remove(at: indexPath.row)
                break
            default:
                break
            }
            
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
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
    @IBAction func GoToSearch(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailFoodVC = storyboard.instantiateViewController(withIdentifier:"ProductListViewController") as! SearchFoodViewController;()
        detailFoodVC.buttonTag = 0
        detailFoodVC.patient = self.patient
        self.navigationController?.pushViewController(detailFoodVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var food = self.consumptions[indexPath.row]
        
        switch indexPath.section {
        case 0:
            food = self.breakfastFoods[indexPath.row]
            break
        case 1:
            food = self.lunchFoods[indexPath.row]
            break
        case 2:
            food = self.dinnerFoods[indexPath.row]
            break
        case 3:
            food = self.snackFoods[indexPath.row]
            break
        default:
            break
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailFoodVC = storyboard.instantiateViewController(withIdentifier:"ProductDetailListViewController") as! FoodDetailViewController;()
        detailFoodVC.foodItem = food.foodMealCompenent
        self.navigationController?.pushViewController(detailFoodVC, animated: true)
    }
}
