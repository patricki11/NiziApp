//
//  PatientListViewController.swift
//  NiziApp
//
//  Created by Samir Yeasin on 29/11/2019.
//  Copyright © 2019 Samir Yeasin. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
class PatientListViewController: UIViewController {

    @IBOutlet weak var patientListTableView : UITableView?
    @IBOutlet weak var patientSearchField : UITextField?

    weak var loggedInAccount : DoctorLogin!
    
    var patientList: [Patient] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("patientList", comment: "")
        getAllPatients()
        setupDataTable()
        setupFilterTextfield()
        createLogoutButton()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        getAllPatients()
    }
    
    func createLogoutButton() {
        let logoutButton = UIBarButtonItem(title: "Uitloggen", style: .plain, target: self, action: #selector(logout))
        self.navigationItem.leftBarButtonItem = logoutButton
    }
    
    func setupFilterTextfield() {
        patientSearchField?.addTarget(self, action: #selector(filterTextfieldChanged(_:)), for: UIControl.Event.editingChanged)
    }
    
    @objc func filterTextfieldChanged(_ textField: UITextField) {
        print("test")
        patientListTableView?.reloadData()
    }
    
    func setupDataTable() {
        patientListTableView?.delegate = self
        patientListTableView?.dataSource = self
    }
    
    @objc func logout() {
        removeAuthorizationToken()
        navigateToLoginPage()
    }
    
    func removeAuthorizationToken() {
        KeychainWrapper.standard.removeObject(forKey: "authToken")
        KeychainWrapper.standard.removeObject(forKey: "patientId")
    }
    
    func navigateToLoginPage() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "ChooseLoginViewController") as! ChooseLoginViewController
        
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    func getAllPatients() {     
        NiZiAPIHelper.getPatients(forDoctor: 3, withAuthorization: KeychainWrapper.standard.string(forKey: "authToken")!).responseData(completionHandler: { response in
            guard let jsonResponse = response.data
            else { return }
            
            let jsonDecoder = JSONDecoder()
            guard let patientList = try? jsonDecoder.decode( [Patient].self, from: jsonResponse )
            else { return }
            
            self.patientList = patientList
            self.patientListTableView?.reloadData()
        })
    }
    
    @IBAction func addNewPatientButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newPatientVC = storyboard.instantiateViewController(withIdentifier: "AddPatientViewController") as! AddPatientViewController
        
        newPatientVC.loggedInAccount = self.loggedInAccount
        self.navigationController?.pushViewController(newPatientVC, animated: true)
    }
}

extension PatientListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getFilteredPatientList().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "PatientListTableViewCell"
        let cell = patientListTableView?.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PatientListTableViewCell

        let filteredPatientList = getFilteredPatientList()
        let patient = filteredPatientList[indexPath.row]
        
        cell.patientNumber.text = String(indexPath.row)
        cell.patientName.text = patient.firstName! + " " + patient.lastName!
        return cell

    }

    func getFilteredPatientList() -> [Patient] {
        let patientName = patientSearchField?.text ?? ""
        
        if(patientName == "") {
            return patientList
        }
        else {
            return patientList.filter { ("\($0.firstName?.lowercased()) \($0.lastName?.lowercased())").contains(patientName.lowercased())}
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // TODO: Volgende patienten ophalen
    }

}

extension PatientListViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let filteredPatientList = getFilteredPatientList()
        navigateToPatientDetailView(patient: filteredPatientList[indexPath.row])
    }
    
    func navigateToPatientDetailView(patient: Patient) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let patientDetailVC = storyboard.instantiateViewController(withIdentifier: "PatientOverviewViewController") as! PatientOverviewViewController
        patientDetailVC.patient = patient
        self.navigationController?.pushViewController(patientDetailVC, animated: true)
    }
}
