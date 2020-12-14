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

    var loggedInAccount : NewUser!
    
    var patientList: [NewPatient] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("PatientList", comment: "")
        getAllPatients()
        setupDataTable()
        setupFilterTextfield()
        createLogoutButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setupActivityIndicator()
        getAllPatients()
    }
    
    func setupActivityIndicator() {
        var refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshPatientList), for: .valueChanged)
        patientListTableView?.refreshControl = refreshControl
    }
    
    @objc func refreshPatientList() {
        patientList = []
        patientListTableView?.reloadData()
        getAllPatients()
    }
    
    func createLogoutButton() {
        let logoutButton = UIBarButtonItem(title: NSLocalizedString("LogOut", comment: ""), style: .plain, target: self, action: #selector(logout))
        self.navigationItem.leftBarButtonItem = logoutButton
    }
    
    func setupFilterTextfield() {
        patientSearchField?.addTarget(self, action: #selector(filterTextfieldChanged(_:)), for: UIControl.Event.editingChanged)
    }
    
    @objc func filterTextfieldChanged(_ textField: UITextField) {
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
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    func getAllPatients() {
        patientListTableView?.refreshControl?.beginRefreshing()
        NiZiAPIHelper.getPatients(forDoctor: loggedInAccount.doctor!, withAuthorization: KeychainWrapper.standard.string(forKey: "authToken")!).responseData(completionHandler: { response in
            guard let jsonResponse = response.data
                else { return }
            
            let jsonDecoder = JSONDecoder()
            guard let patientList = try? jsonDecoder.decode( [NewPatient].self, from: jsonResponse )
                else { return }
            
            self.patientList = patientList
            self.patientListTableView?.refreshControl?.endRefreshing()
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
        cell.patientName.text = (patient.userObject?.first_name ?? "") + " " + (patient.userObject?.last_name ?? "")
        return cell

    }

    func getFilteredPatientList() -> [NewPatient] {
        let patientName = patientSearchField?.text ?? ""
        
        if(patientName == "") {
            return patientList
        }
        else {
            return patientList.filter { ("\($0.userObject?.first_name.lowercased()) \($0.userObject?.last_name.lowercased())").contains(patientName.lowercased())}
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deletePatient(patient: patientList[indexPath.row])
            patientList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func navigateToPatientDetailView(patient: NewPatient) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let patientDetailVC = storyboard.instantiateViewController(withIdentifier: "PatientOverviewViewController") as! PatientOverviewViewController
        patientDetailVC.patient = patient
        patientDetailVC.doctorId = loggedInAccount.doctor
        self.navigationController?.pushViewController(patientDetailVC, animated: true)
    }
    
    func deletePatient(patient: NewPatient) {
        deletePatientObject(forPatient: patient)
    }
    
    func deletePatientObject(forPatient patient: NewPatient) {
        NiZiAPIHelper.deletePatient(byId: patient.id!, authenticationCode: KeychainWrapper.standard.string(forKey: "authToken")!).responseData(completionHandler: { _ in
            
            self.deletePatientUser(forUser: patient.user ?? patient.userObject?.id ?? 0)
        })
    }
    
    func deletePatientUser(forUser userId: Int) {
        NiZiAPIHelper.deleteUser(byId: userId, authenticationCode: KeychainWrapper.standard.string(forKey: "authToken")!).responseData(completionHandler: { _ in
            self.showPatientDeletedMessage()
        })
    }
    
    func showPatientDeletedMessage() {
        let alertController = UIAlertController(
            title:NSLocalizedString("patientDeletedTitle", comment: ""),
            message: NSLocalizedString("patientDeletedMessage", comment: ""),
            preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "Ok"), style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
}
