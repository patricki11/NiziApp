//
//  DairyListViewController.swift
//  NiziApp
//
//  Created by Samir Yeasin on 29/11/2019.
//  Copyright © 2019 Samir Yeasin. All rights reserved.
//

import UIKit

class DairyListViewController: UIViewController {
    @IBOutlet weak var DiaryDietaryList: UITableView!
    @IBOutlet weak var DiaryRecentFood: UITableView!
    
    @IBOutlet weak var DairyDayLabel: UILabel!
    @IBOutlet weak var DiaryTitleLabel: UILabel!
    @IBOutlet weak var DiaryAddLabel: UILabel!
    
    var productList: [Food] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLanguageSpecificText()
        // Do any additional setup after loading the view.
    }
    
    func setLanguageSpecificText() {
        DairyDayLabel.text = NSLocalizedString("DiaryDayLabel", comment: "")
        DiaryTitleLabel.text = NSLocalizedString("DiaryTitle", comment: "")
        DiaryAddLabel.text = NSLocalizedString("DiaryAddProduct", comment: "")
    }
    
    
    @IBAction func DiaryPreviousDayButton(_ sender: Any) {
    }
    @IBAction func DiaryNextDayButton(_ sender: Any) {
    }
}
