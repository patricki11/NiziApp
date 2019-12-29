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
        NiZiAPIHelper.getAllConsumptions(forPatient: 57, between: "2019-12-10", and: "2019-12-10", authenticationCode: "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImtpZCI6Ik5ERkdPRFUxTnpJNFJEZ3lNakkxUmtFMU5EZ3dRMEUxTkVJM05UTTBSRGRFUTBFNE5FWkdNZyJ9.eyJpc3MiOiJodHRwczovL2FwcG5pemkuZXUuYXV0aDAuY29tLyIsInN1YiI6ImF1dGgwfDVkZGMyMThlOTg3MDRiMGVmNmM0NjY4YyIsImF1ZCI6WyJhcHBuaXppLm5sL2FwaSIsImh0dHBzOi8vYXBwbml6aS5ldS5hdXRoMC5jb20vdXNlcmluZm8iXSwiaWF0IjoxNTc3MTg0OTk3LCJleHAiOjE1NzcyNzEzOTcsImF6cCI6IlhydVlCWmVFWklKbDYzSDF5OWxIcURDZzhhTWhKbXhjIiwic2NvcGUiOiJvcGVuaWQgcHJvZmlsZSIsImd0eSI6InBhc3N3b3JkIn0.To3Bbm7d4JUif3I-u1RZiav2-Dlw6zFlhFCooc4ClsRRyLkuVKr7PqkeiBGCP9ndRt2_0jmAkQr1sDjen-XPD7D9c0gamrmnsJLpydl9jM37zKBb-nplSgzDhzvl1msBax-ROdocmLtFZifV4PuaGK52VpjJ3YI7LZWhJraWjbDuQLB7VYT9n72gKOLZrrAdyLd-CgeRTO3Le1JR023k55DPClOecW_Fvp-ijD4d8F05EBTblb6H_aMXeMucmVtXSsK7e4VgWJwTUcjJnXxwtJ3Euq_JFVU5JjHYkppclpjRPB6K3PlIbdFy-w887AXOIJ-dnP8xvBRG9xrukFdyGQ").responseData(completionHandler: { response in
            
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
