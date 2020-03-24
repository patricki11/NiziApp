//
//  ConversationViewController.swift
//  NiziApp
//
//  Created by Samir Yeasin on 24/03/2020.
//  Copyright © 2020 Samir Yeasin. All rights reserved.
//

import UIKit

struct conversation {
    var text: String!
}

class ConversationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var headers     : [conversation] = []
    @IBOutlet weak var conversationtable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headers = [conversation.init(text: "Goed bezig"),conversation.init(text: "Meer letten op je Kalium inname"),conversation.init(text: "Volgende week"),conversation.init(text: "Blijven volhouden")]
        // Do any additional setup after loading the view.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return headers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchFoodCell = tableView.dequeueReusableCell(withIdentifier: "ConversationCell", for: indexPath) as! SearchFoodTableViewCell
        let idx: Int = indexPath.row
        searchFoodCell.textLabel?.text = headers[idx].text
        searchFoodCell.accessoryType = .disclosureIndicator
        
        return searchFoodCell
    }
    
}
