//
//  DairyListViewController.swift
//  NiziApp
//
//  Created by Samir Yeasin on 29/11/2019.
//  Copyright © 2019 Samir Yeasin. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

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
        NiZiAPIHelper.getAllConsumptions(forPatient: 57, between: "2019-12-10", and: "2019-12-10", authenticationCode: KeychainWrapper.standard.string(forKey: "authToken")!).responseData(completionHandler: { response in
            
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
