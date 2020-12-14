//
//  ConversationViewController.swift
//  NiziApp
//
//  Created by Samir Yeasin on 24/03/2020.
//  Copyright © 2020 Samir Yeasin. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class ConversationViewController: UIViewController {
    var conversations : [NewConversation] = []
    var selectedIndex: IndexPath = IndexPath(row: 0, section: 0)

    @IBOutlet weak var conversationtable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        getConversation()
        SetupTableView()
    }

    fileprivate func SetupTableView(){
        view.addSubview(conversationtable)
        conversationtable.translatesAutoresizingMaskIntoConstraints = false
        conversationtable.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        conversationtable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        conversationtable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        conversationtable.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        conversationtable.register(ConversationCell.self, forCellReuseIdentifier: "cell")
        conversationtable.delegate = self
        conversationtable.dataSource = self
    }
    
    func getConversation() {
        let patient = Int(KeychainWrapper.standard.string(forKey: "patientId")!)
        
        NiZiAPIHelper.GetConversations(withToken: KeychainWrapper.standard.string(forKey: "authToken")!, withPatient: patient!).responseData(completionHandler: { response in
            
            guard let jsonResponse = response.data
                else { print("temp1"); return }
            
            let jsonDecoder = JSONDecoder()
            guard let foodlistJSON = try? jsonDecoder.decode( [NewConversation].self, from: jsonResponse )
                else { print("temp2"); return }
            
            self.conversations = foodlistJSON
            self.conversationtable?.reloadData()
        })
    }
}

extension ConversationViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedIndex == indexPath {return 200}
        return 60
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"cell", for: indexPath) as! ConversationCell
        cell.data = conversations[indexPath.row]
        cell.selectionStyle = .none
        cell.animate()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath
        
        tableView.beginUpdates()
        tableView.reloadRows(at: [selectedIndex], with: .none)
        tableView.endUpdates()
    }
}
