//
//  PatientListViewController.swift
//  NiziApp
//
//  Created by Samir Yeasin on 29/11/2019.
//  Copyright © 2019 Samir Yeasin. All rights reserved.
//

import UIKit

class PatientListViewController: UIViewController {

    @IBOutlet weak var patientListTableView : UITableView?
    @IBOutlet weak var patientSearchField : UITextField?

    var patientList: [Patient] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("patientList", comment: "")
        //getAllPatients()
        // Do any additional setup after loading the view.
    }
    
    func getAllPatients() {
        let doctorId = 3;
        NiZiAPIHelper.getPatients(forDoctor: doctorId).responseData(completionHandler: { response in
            
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
        self.navigationController?.pushViewController(newPatientVC, animated: true)
    }
}

extension PatientListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return patientList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        return UITableViewCell()

    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // TODO: Volgende patienten ophalen
    }

}

extension PatientListViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TO DO: Go to Patient
    }
}
