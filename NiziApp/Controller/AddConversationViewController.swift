//
//  AddConversationViewController.swift
//  NiziApp
//
//  Created by Patrick Dammers on 04/12/2020.
//  Copyright © 2020 Samir Yeasin. All rights reserved.
//

import Foundation
import UIKit
import SwiftKeychainWrapper

class AddConversationViewController: UIViewController {
    var conversations : [NewConversation] = []
    var selectedIndex: IndexPath = IndexPath(row: 0, section: 0)
    var patientId : Int!
    var doctorId : Int!
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        return formatter
    }()
    
    @IBOutlet weak var newConversationField: UITextField!
    
    @IBAction func createNewConversation(_ sender: Any) {
        let newConversation = NewConversation(
            id : 0,
            title : "title",
            comment: "comment",
            date: dateFormatter.string(from: Date()),
            isRead : false,
            doctor : nil,
            doctorId: doctorId,
            patient : nil,
            patientId: patientId)
    }
    
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
        conversationtable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        conversationtable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
        conversationtable.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        conversationtable.register(ConversationCell.self, forCellReuseIdentifier: "cell")
        conversationtable.delegate = self
        conversationtable.dataSource = self
    }
    
    func getConversation() {
        NiZiAPIHelper.GetConversations(withToken: KeychainWrapper.standard.string(forKey: "authToken")!, withPatient: patientId).responseData(completionHandler: { response in
            
            guard let jsonResponse = response.data
                else { print("temp1"); return }
            
            let jsonDecoder = JSONDecoder()
            guard let conversations = try? jsonDecoder.decode( [NewConversation].self, from: jsonResponse )
                else { print("temp2"); return }
            
            self.conversations = conversations
            self.conversationtable?.reloadData()
        })
    }
}

extension AddConversationViewController : UITableViewDelegate, UITableViewDataSource {
    
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
