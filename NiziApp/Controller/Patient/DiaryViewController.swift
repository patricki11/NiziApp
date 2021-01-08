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

class DiaryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NavigateToFood {
    func goToSearch(mealTime: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailFoodVC = storyboard.instantiateViewController(withIdentifier:"ProductListViewController") as! SearchFoodViewController;()
        detailFoodVC.buttonTag = 0
        detailFoodVC.patient = self.patient
        self.navigationController?.pushViewController(detailFoodVC, animated: true)
    }
    
    
    var heightHeader : CGFloat = 44
    
    @IBOutlet weak var diaryTable: UITableView!
    var consumptions   : [NewConsumption] = []
    var breakfastFoods : [NewConsumption] = []
    var lunchFoods     : [NewConsumption] = []
    var dinnerFoods    : [NewConsumption] = []
    var snackFoods     : [NewConsumption] = []
    var headers        : [postStruct] = []
    var patient        : NewPatient?
    var currentDayCounter : Int = 0
    var selectedDate : Date?
    
    lazy var apiDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        return formatter
    }()
    
    lazy var readableDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM YYYY"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let patient = Int(KeychainWrapper.standard.string(forKey: "patientId")!)
        self.patient = createNewPatientObject(id: patient!, gender: "Male", dateOfBirth: "1995-02-08", createdAt: "2020-10-07T11:49:26.000Z", updatedAt: "2020-10-07T12:04:08.000Z", doctor: 1, user: 1)
        headers = [postStruct.init(image: #imageLiteral(resourceName: "Sunrise_s"), text: "Ontbijt"),postStruct.init(image: #imageLiteral(resourceName: "Sun"), text: "Lunch"),postStruct.init(image: #imageLiteral(resourceName: "Sunset"), text: "Avondeten"),postStruct.init(image: #imageLiteral(resourceName: "Food"), text: "Snack")]
        changeCurrentDayLabel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getConsumption(Date: "")
        self.diaryTable.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let patient = Int(KeychainWrapper.standard.string(forKey: "patientId")!)
        breakfastFoods  = []
        lunchFoods      = []
        dinnerFoods     = []
        snackFoods      = []
        NiZiAPIHelper.readAllConsumption(withToken: KeychainWrapper.standard.string(forKey: "authToken")!, withPatient: patient!, withStartDate: dateFormatter.string(from: selectedDate!)).responseData(completionHandler: { response in
            
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
        /*
        NiZiAPIHelper.deleteConsumption(withId: id, authenticationCode: KeychainWrapper.standard.string(forKey: "authToken")!).responseData(completionHandler: { response in
            guard response.data != nil
                else { print("temp1"); return }
        })
 */
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
            portion = (dinnerFoods[indexPath.row].amount)! * (dinnerFoods[indexPath.row].foodMealCompenent?.portionSize)!
            portionSize = portion.description + " " + dinnerFoods[indexPath.row].weightUnit!.short
            break
        case 3:
            navigationTitle = (snackFoods[indexPath.row].foodMealCompenent?.name)!
            amountText = (snackFoods[indexPath.row].amount?.description)!
            portion = (snackFoods[indexPath.row].amount)! * (snackFoods[indexPath.row].foodMealCompenent?.portionSize)!
            portionSize = portion.description + " " + snackFoods[indexPath.row].weightUnit!.short
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
        return 80.0;//Choose your custom row height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)?.first as! HeaderView
        
        headerView.headerImageView.image = headers[section].image
        headerView.headerLabel.text = headers[section].text
        headerView.AddButton.tag = section
        headerView.mealTime = headers[section].text
        headerView.navigation = self
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
        let detailFoodVC = storyboard.instantiateViewController(withIdentifier:"DetailFoodViewController") as! DetailFoodViewController;()
        detailFoodVC.foodItem = food.foodMealCompenent
        detailFoodVC.consumptionId = food.id!
        detailFoodVC.isDiaryDetail = true
        self.navigationController?.pushViewController(detailFoodVC, animated: true)
    }
    
    @IBAction func previousDay(_ sender: Any) {
        currentDayCounter -= 1
        changeCurrentDayLabel()
        getConsumption(Date: "")
    }
    
    @IBAction func nextDay(_ sender: Any) {
        currentDayCounter += 1
        changeCurrentDayLabel()
        getConsumption(Date: "")
    }
    
    
    @IBOutlet weak var currentWeekLabel: UILabel!
    
    func changeCurrentDayLabel() {

        selectedDate = Calendar.current.date(byAdding: .day, value: currentDayCounter, to: Date())
                
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-YYYY"
        
        let secondDateFormatter = DateFormatter()
        secondDateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedDate = secondDateFormatter.string(from: selectedDate!)
        let finalDate = formattedDate + "T00:00:00.000Z"
        
        saveDate(date: finalDate)
        
        if(currentDayCounter == -1) {
            currentWeekLabel.text = NSLocalizedString("Yesterday", comment: "")
        }
        else if(currentDayCounter == 0) {
            currentWeekLabel.text = NSLocalizedString("Today", comment: "")
        }
        else if(currentDayCounter == 1) {
            currentWeekLabel.text = NSLocalizedString("Tomorrow", comment: "")
        }
        else {
            currentWeekLabel.text = "\(dateFormatter.string(from: selectedDate!))"
        }
    }
}
