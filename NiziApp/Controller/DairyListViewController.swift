//
//  DairyListViewController.swift
//  NiziApp
//
//  Created by Samir Yeasin on 29/11/2019.
//  Copyright © 2019 Samir Yeasin. All rights reserved.
//

import UIKit

class DairyListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var consumptions: [ConsumptionView] = [] 

    @IBOutlet weak var DiaryDietaryList: UITableView!
    @IBOutlet weak var DiaryRecentFood: UITableView!
    
    @IBOutlet weak var DairyDayLabel: UILabel!
    @IBOutlet weak var DiaryTitleLabel: UILabel!
    @IBOutlet weak var DiaryAddLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLanguageSpecificText()
        getConsumption()
    }
    
    func getConsumption() {
        NiZiAPIHelper.getAllConsumptions(forPatient: 57, between: "2019-12-10", and: "2019-12-10", authenticationCode: "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImtpZCI6Ik5ERkdPRFUxTnpJNFJEZ3lNakkxUmtFMU5EZ3dRMEUxTkVJM05UTTBSRGRFUTBFNE5FWkdNZyJ9.eyJpc3MiOiJodHRwczovL2FwcG5pemkuZXUuYXV0aDAuY29tLyIsInN1YiI6ImF1dGgwfDVkZGMyMThlOTg3MDRiMGVmNmM0NjY4YyIsImF1ZCI6WyJhcHBuaXppLm5sL2FwaSIsImh0dHBzOi8vYXBwbml6aS5ldS5hdXRoMC5jb20vdXNlcmluZm8iXSwiaWF0IjoxNTc2MDI0MzQ3LCJleHAiOjE1NzYxMTA3NDcsImF6cCI6IlhydVlCWmVFWklKbDYzSDF5OWxIcURDZzhhTWhKbXhjIiwic2NvcGUiOiJvcGVuaWQgcHJvZmlsZSIsImd0eSI6InBhc3N3b3JkIn0.C0IRzdof7QGU2q8OoxjzHeFJPMFlsW8B1tQr-aqjh1hzg15eRopc1AOiHxzY46O-ddVCZZP6P47quJ7tFc2omUlFqrlDgLkjA50U5xwhzNv1KEbhnj_tj8OO0XPRzRSBFj_nfNDTpMewyTtz7j6oHkLGaIDl7rBvlnzrPFxKjCH2NpvbDUjsLWNJMezdMtoLoInuN3H9Gzpr3sSdaN0pfdvvpWjV6eKf4CTzWQUfwmaMwKA5oRWQzgEodwGxklNl2RwiH--j_2-EvhyxRtMX94L1vMBFquXgqVpcHWzdrCfQ5P90cat9jbK1VmzoATSF-S6XPPIA3_YaDfC4HAhhEg").responseData(completionHandler: { response in
            
            guard let jsonResponse = response.data
            else { print("temp1"); return }
            
            let jsonDecoder = JSONDecoder()
            guard let consumptionlist = try? jsonDecoder.decode( Diary.self, from: jsonResponse )
            else { print("temp2"); return }
            
            self.consumptions = consumptionlist.consumptions
            self.DiaryRecentFood?.reloadData()
        })
    }
    func setLanguageSpecificText() {
        DairyDayLabel.text = NSLocalizedString("DiaryDayLabel", comment: "")
        DiaryTitleLabel.text = NSLocalizedString("DiaryTitle", comment: "")
        DiaryAddLabel.text = NSLocalizedString("DiaryAddProduct", comment: "")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return consumptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let diarycell = tableView.dequeueReusableCell(withIdentifier: "diarycell", for: indexPath) as! DiaryTableViewCell
        let idx: Int = indexPath.row
        diarycell.productTitle?.text = consumptions[idx].foodName
        return diarycell
    }
    
    @IBAction func DiaryPreviousDayButton(_ sender: Any) {
    }
    @IBAction func DiaryNextDayButton(_ sender: Any) {
    }
}
