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
    let patientIntID    : Int? = Int(KeychainWrapper.standard.string(forKey: "patientId")!)
    var consumptions    : [ConsumptionView] = []
    var breakfastFoods   : [ConsumptionView] = []
    var lunchFoods       : [ConsumptionView] = []
    var dinnerFoods      : [ConsumptionView] = []
    var snackFoods       : [ConsumptionView] = []
    var headers     : [postStruct] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headers = [postStruct.init(image: #imageLiteral(resourceName: "Sunrise_s"), text: "Ontbijt"),postStruct.init(image: #imageLiteral(resourceName: "Sun"), text: "Lunch"),postStruct.init(image: #imageLiteral(resourceName: "Sunset"), text: "Avond"),postStruct.init(image: #imageLiteral(resourceName: "Food"), text: "Snack")]
        print(KeychainWrapper.standard.string(forKey: "patientId"))
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let formattedDate = format.string(from: date)
        saveDate(date: formattedDate)
        //getConsumption(Date: formattedDate)
        SetupDatePicker()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getConsumption(Date: KeychainWrapper.standard.string(forKey: "date")!)
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
            case "Snack":
                snackFoods.append(food)
                break
            case "Lunch":
                lunchFoods.append(food)
                break
            case "AvondEten":
                dinnerFoods.append(food)
            default:
                print("no valid food")
                break
            }
        }
        
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
        NiZiAPIHelper.getAllConsumptions(forPatient: patientIntID!, between: date, and: date, authenticationCode: KeychainWrapper.standard.string(forKey: "authToken")!).responseData(completionHandler: { response in
            
            guard let jsonResponse = response.data
                else { print("temp1"); return }
            
            let jsonDecoder = JSONDecoder()
            guard let consumptionlist = try? jsonDecoder.decode( Diary.self, from: jsonResponse )
                else { print("temp2"); return }
            
            self.consumptions = consumptionlist.consumptions
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
    
    /*func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
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
     }*/
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "diarytablecell", for: indexPath)
        
        var navigationTitle = ""
        
        switch indexPath.section {
        case 0:
            navigationTitle = breakfastFoods[indexPath.row].foodName!
            break
        case 1:
            navigationTitle = lunchFoods[indexPath.row].foodName!
            break
        case 2:
            navigationTitle = dinnerFoods[indexPath.row].foodName!
            break
        case 3:
            navigationTitle = snackFoods[indexPath.row].foodName!
            break
        default:
            break
        }
        cell.textLabel?.text = navigationTitle
        cell.accessoryType = .detailButton
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.Deleteconsumption(Id: consumptions[indexPath.row].consumptionId)
            self.breakfastFoods.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            //self.getConsumption(Date: KeychainWrapper.standard.string(forKey: "date")!)
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
            print("Hello?")
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
        self.navigationController?.pushViewController(detailFoodVC, animated: true)
    }
    
 
    
    
}
