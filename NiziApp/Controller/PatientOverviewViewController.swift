//
//  PatientOverviewViewController.swift
//  NiziApp
//
//  Created by Samir Yeasin on 02/01/2020.
//  Copyright © 2020 Samir Yeasin. All rights reserved.
//

import Foundation
import UIKit
import SwiftKeychainWrapper

class PatientOverviewViewController : UIViewController
{
    var patientId : Int!
    var doctorId : Int!
    weak var patient : NewPatient!
    @IBOutlet weak var ageGenderLabel: UILabel!
    
    @IBOutlet weak var patientNameLabel: UILabel!
    
    @IBOutlet weak var dayOverviewLabel: UILabel!
    @IBOutlet weak var guidelineTableView: UITableView!
    
    @IBOutlet weak var useWeekLabel: UILabel!
    @IBOutlet weak var useDayLabel: UILabel!
    @IBOutlet weak var selectDayWeekSwitch: UISwitch!
    
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
    
    var patientGuidelines : [NewDietaryManagement] = []
    var patientConsumption : [NewConsumption] = []
    var currentDayCounter : Int = 0
   
    var selectedDate : Date?
    var firstDayOfWeek : Date?
    var lastDayOfWeek : Date?
    
    var useWeek : Bool = true
    var currentDayOfWeek : Int = Calendar.current.component(.weekday, from: Date())
    
    @IBOutlet weak var currentWeekLabel: UILabel!
    
    @IBAction func getPreviousWeek(_ sender: Any) {
        currentDayCounter -= 1
        
        if(useWeek) {
            changeCurrentWeekLabel()
            getConsumptionsForWeek()
        }
        else {
            changeCurrentDayLabel()
            getConsumptions()
        }
    }
    
    @IBAction func getNextWeek(_ sender: Any) {
        currentDayCounter += 1
        
        if(useWeek) {
            changeCurrentWeekLabel()
            getConsumptionsForWeek()
        }
        else {
            changeCurrentDayLabel()
            getConsumptions()
        }
    }
    
    func changeAgeGenderLabel() {
        let gender = patient.gender
        let birthdate = apiDateFormatter.date(from: patient.dateOfBirth)
        let readableDateOfBirth = readableDateFormatter.string(from: birthdate!)
        
        let ageComponents = Calendar.current.dateComponents([.year], from: birthdate!, to: Date())
        let age = ageComponents.year!
        
        ageGenderLabel.text = "\(gender) - \(readableDateOfBirth) (\(age))"
    }
    
    func changeCurrentDayLabel() {

        dayOverviewLabel.text = NSLocalizedString("dayOverview", comment: "")
        selectedDate = Calendar.current.date(byAdding: .day, value: currentDayCounter, to: Date())
                
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-YYYY"
        
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
        
        updateGuidelines()
    }
    
    func changeCurrentWeekLabel() {
        
        dayOverviewLabel.text = NSLocalizedString("weekOverview", comment: "")
        
        firstDayOfWeek = Calendar.current.date(byAdding: .day, value: 7*currentDayCounter, to: Date().startOfWeek!)
        lastDayOfWeek = Calendar.current.date(byAdding: .day, value: 7*currentDayCounter, to: Date().endOfWeek!)
        
        if(currentDayCounter == -1) {
            currentWeekLabel.text = NSLocalizedString("lastWeek", comment: "")
        }
        else if(currentDayCounter == 0) {
            currentWeekLabel.text = NSLocalizedString("thisWeek", comment: "")
        }
        else if(currentDayCounter == 1) {
            currentWeekLabel.text = NSLocalizedString("nextWeek", comment: "")
        }
        else {
            currentWeekLabel.text = "\(readableDateFormatter.string(from: firstDayOfWeek!)) - \(readableDateFormatter.string(from:lastDayOfWeek!))"
        }
        
        updateGuidelines()
    }
    
    func updateGuidelines() {
        guidelineTableView?.reloadData()
    }
    
    override func viewDidLoad() {
        getDataFromUserDefaults()

        self.navigationController?.navigationBar.isTranslucent = true
        title = NSLocalizedString("Overview", comment: "")

        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getDataFromUserDefaults()
        super.viewDidAppear(true)
    }
    
    func getDataFromUserDefaults() {
        let defaults = UserDefaults.standard
        patientId = defaults.integer(forKey: "patient")
        doctorId = defaults.integer(forKey: "doctorId")
        
        NiZiAPIHelper.getPatient(byId: patientId, authenticationCode: KeychainWrapper.standard.string(forKey: "authToken")!).responseData(completionHandler: { response in
            guard let jsonResponse = response.data
            else { return }
            
            let jsonDecoder = JSONDecoder()
            guard let patient = try? jsonDecoder.decode(NewPatient.self, from: jsonResponse )
            else { return }
            
            self.patient = patient
            
            self.getPatientOverviewData()
        })
    }
    
    func getPatientOverviewData() {
        setupTableView()
        setupDayWeekSelector()
        setLanguageSpecificText()
        getDietaryGuidelines()
        changeAgeGenderLabel()
        
        if(useWeek) {
            changeCurrentWeekLabel()
            getConsumptionsForWeek()
        }
        else {
            changeCurrentDayLabel()
            getConsumptions()
        }
    }
    
    func setupActivityIndicator() {
        var refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshGuidelineList), for: .valueChanged)
        guidelineTableView?.refreshControl = refreshControl
    }
    
    func setupDayWeekSelector() {
        selectDayWeekSwitch.onTintColor = UIColor.systemGreen
        selectDayWeekSwitch.backgroundColor = UIColor.systemGreen
        selectDayWeekSwitch.layer.cornerRadius = selectDayWeekSwitch.frame.height / 2.0
        selectDayWeekSwitch.backgroundColor = UIColor.systemGreen
        selectDayWeekSwitch.clipsToBounds = true
    }
    
    @objc func refreshGuidelineList() {
        patientGuidelines = []
        guidelineTableView?.reloadData()
        getDietaryGuidelines()
    }
    
    func setLanguageSpecificText() {
        patientNameLabel.text = "\(patient.userObject!.first_name) \(patient.userObject!.last_name)"
        useDayLabel.text = "Dag"
        useWeekLabel.text = "Week"
    }
    
    @IBAction func ChangeDayWeekSelection(_ sender: Any) {
        if(selectDayWeekSwitch.isOn) {
            useWeek = true
            currentDayCounter = currentDayCounter / 7
        }
        else {
            useWeek = false
            currentDayCounter = currentDayCounter * 7
        }
        
        if(useWeek) {
            changeCurrentWeekLabel()
            getConsumptionsForWeek()
        }
        else {
            changeCurrentDayLabel()
            getConsumptions()
        }
    }
    
    func setupTableView() {
        guidelineTableView.delegate = self
        guidelineTableView.dataSource = self
    }
    
    @IBAction func editPatient(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let patientDetailVC = storyboard.instantiateViewController(withIdentifier: "EditPatientViewController") as! EditPatientViewController
        patientDetailVC.patientId = patientId
        self.navigationController?.pushViewController(patientDetailVC, animated: true)
    }
    
    @IBAction func navigateToConversations(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let conversationVC = storyboard.instantiateViewController(withIdentifier: "AddConversationViewController") as! AddConversationViewController
        conversationVC.patientId = patientId
        conversationVC.doctorId = doctorId
        self.navigationController?.pushViewController(conversationVC, animated: true)
    }
    
    @IBAction func navigateToDiary(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let diaryVC = storyboard.instantiateViewController(withIdentifier: "ShowPatientDiaryViewController") as! ShowPatientDiaryViewController
        diaryVC.patient = patient
        self.navigationController?.pushViewController(diaryVC, animated: true)
    }
    
    func getDietaryGuidelines() {
        guidelineTableView.refreshControl?.beginRefreshing()
        NiZiAPIHelper.getDietaryManagement(forDiet: patientId, authenticationCode: KeychainWrapper.standard.string(forKey: "authToken")!).response(completionHandler: {response in
            
            guard let jsonResponse = response.data else { return }

            let jsonDecoder = JSONDecoder()
            
            guard let guidelines = try? jsonDecoder.decode([NewDietaryManagement].self, from: jsonResponse) else { return }
            
            self.patientGuidelines = guidelines
            
            self.guidelineTableView.reloadData()
            self.guidelineTableView.refreshControl?.endRefreshing()
        })
    }
    
    func getConsumptions() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        NiZiAPIHelper.readAllConsumption(withToken: KeychainWrapper.standard.string(forKey: "authToken")!, withPatient: patientId!, withStartDate: dateFormatter.string(from: selectedDate!)).response(completionHandler: { response in
            
            guard let jsonResponse = response.data else { return }
            
            let jsonDecoder = JSONDecoder()
            
            guard let consumptions = try? jsonDecoder.decode([NewConsumption].self, from: jsonResponse) else { return }
            
            self.patientConsumption = consumptions
            
            self.guidelineTableView.reloadData()
        })
    }
    
    func getConsumptionsForWeek() {
        NiZiAPIHelper.readAllConsumption(withToken: KeychainWrapper.standard.string(forKey: "authToken")!, withPatient: patientId!, betweenDate: apiDateFormatter.string(from: firstDayOfWeek!), and: apiDateFormatter.string(from: lastDayOfWeek!)).response(completionHandler: { response in
            
            guard let jsonResponse = response.data else { return }
            
            let jsonDecoder = JSONDecoder()
            
            guard let consumptions = try? jsonDecoder.decode([NewConsumption].self, from: jsonResponse) else { return }
            
            self.patientConsumption = consumptions
            
            self.guidelineTableView.reloadData()
        })
    }
}

extension PatientOverviewViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return patientGuidelines.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "PatientGuidelineTableViewCell"
        let cell = guidelineTableView?.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PatientGuidelineTableViewCell

        let filteredList = patientGuidelines
        let guideline = filteredList[indexPath.row]
        var floatTotal : Float = getTotalForCorrespondingCategory(category: (guideline.dietaryRestrictionObject?.plural)!)
        var total : Int = Int(floatTotal)
        
        var progressView = cell.guidelineChartView as! CircularProgressView
        progressView.progressAnimation(minimum: guideline.minimum, maximum: guideline.maximum, currentTotal: total)
       
        cell.guidelineNameLabel.text = guideline.dietaryRestrictionObject?.plural

        if((guideline.minimum != 0 && guideline.minimum != nil) && (guideline.maximum != 0 && guideline.maximum != nil)) {
            cell.firstGuidelineValueLabel.text = "\( NSLocalizedString("Minimum", comment: "")) \(guideline.minimum!)"
            cell.secondGuidelineValueLabel.text = "\( NSLocalizedString("Maximum", comment: "")) \(guideline.maximum!)"
            
            if(total < guideline.maximum!) {
                cell.feedbackLabel.text = NSLocalizedString("keepGoingIntake", comment: "")
                cell.feedbackLabel.textColor = UIColor.systemOrange
            }
            else if(total > guideline.minimum! && total < guideline.maximum!) {
                cell.feedbackLabel.text = NSLocalizedString("goodIntake", comment: "")
                cell.feedbackLabel.textColor = UIColor.systemGreen
            }
            else if(total > guideline.maximum!) {
                cell.feedbackLabel.text = NSLocalizedString("limitIntake", comment: "")
                cell.feedbackLabel.textColor = UIColor.systemRed
            }
        }
        else if(guideline.minimum != 0 && guideline.minimum != nil) {
            cell.firstGuidelineValueLabel.text = "\( NSLocalizedString("Minimum", comment: "")) \(guideline.minimum!)"
            cell.secondGuidelineValueLabel.text = ""
            
            if(total > guideline.minimum!) {
                cell.feedbackLabel.text = NSLocalizedString("goodIntake", comment: "")
                cell.feedbackLabel.textColor = UIColor.systemGreen
            }
            else if(total < guideline.minimum!) {
                cell.feedbackLabel.text = NSLocalizedString("keepGoingIntake", comment: "")
                cell.feedbackLabel.textColor = UIColor.systemOrange
            }
        }
        else if(guideline.maximum != 0 && guideline.maximum != nil) {
            cell.firstGuidelineValueLabel.text = "\( NSLocalizedString("Maximum", comment: "")) \(guideline.maximum!)"
            cell.secondGuidelineValueLabel.text = ""
            
            if(total <= guideline.maximum!) {
                cell.feedbackLabel.text = NSLocalizedString("goodIntake", comment: "")
                cell.feedbackLabel.textColor = UIColor.systemGreen
            }
            else if(total > guideline.maximum!) {
                cell.feedbackLabel.text = NSLocalizedString("limitIntake", comment: "")
                cell.feedbackLabel.textColor = UIColor.systemRed
            }
        }
        
        if(total == 0) {
            cell.feedbackLabel.text = NSLocalizedString("noIntake", comment: "")
            cell.feedbackLabel.textColor = UIColor.systemOrange
        }
        
        cell.guidelineIconImageView.image = getCorrespondingImageForCategory(category: guideline.dietaryRestrictionObject?.description ?? "")
        
        return cell

    }
    
    func getTotalForCorrespondingCategory(category: String) -> Float {
        var total : Float = 0
        if(category.contains("Calorie"))
        {
            for consumption in patientConsumption
            {
                total += consumption.foodMealCompenent?.kcal ?? 0
            }
        }
        else if(category.contains("Vocht"))
        {
            for consumption in patientConsumption
            {
                total += consumption.foodMealCompenent?.water ?? 0
            }
        }
        else if(category.contains("Natrium"))
        {
            for consumption in patientConsumption
            {
                total += consumption.foodMealCompenent?.sodium ?? 0
            }
        }
        else if(category.contains("Vezel"))
        {
            for consumption in patientConsumption
            {
                total += consumption.foodMealCompenent?.fiber ?? 0
            }
        }
        else if(category.contains("Eiwit"))
        {
            for consumption in patientConsumption
            {
                total += consumption.foodMealCompenent?.protein ?? 0
            }
        }
        else if(category.contains("Kalium"))
        {
            for consumption in patientConsumption
            {
                total += consumption.foodMealCompenent?.potassium ?? 0
            }
        }
        
        if(useWeek) {
            if(currentDayCounter == 0) {
                total = total / Float(currentDayOfWeek)
            }
            else {
                total = total / 7
            }
        }
        
        return total
    }
    
    func getCorrespondingImageForCategory(category: String) -> UIImage? {
        
        if(category.contains("Calorie")) {
            return UIImage(named: "Calories_s")!
        }
        else if(category.contains("Vocht"))
        {
            return UIImage(named: "Water_s")!
        }
        else if(category.contains("Natrium")) {
            return UIImage(named: "Salt_s")!
        } else if(category.contains("Vezel")) {
            return UIImage(named: "Grain_s")!
        }
        else if(category.contains("Eiwit")) {
            return UIImage(named: "Protein_s")!
        }
        else if(category.contains("Kalium")) {
            return UIImage(named: "Salt_s")!
        }
        else {
            return nil
        }
    }
    
    func getCorrespondingType(category: String) -> String {
        if(category.contains("Calorie")) {
            return "kcal"
        }
        else if(category.contains("Vocht")) {
            return "gram"
        }
        else if(category.contains("Natrium")) {
            return "gram"
        }
        else if(category.contains("Vezel")) {
            return "gram"
        }
        else if(category.contains("Eiwit")) {
            return "gram"
        }
        else if(category.contains("Kalium")) {
            return "gram"
        }
        else {
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // TODO: Volgende patienten ophalen
    }

}

extension PatientOverviewViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
}

extension Date {
    var startOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 1, to: sunday)
    }

    var endOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 7, to: sunday)
    }
}
