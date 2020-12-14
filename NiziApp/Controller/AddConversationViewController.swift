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
    
    @IBOutlet weak var conversationtable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Conversations", comment: "")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAddConversationViewModal))
        getConversation()
        SetupTableView()
        setupActivityIndicator()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAddConversationViewModal))
        getConversation()
        SetupTableView()
    }
    
    func setupActivityIndicator() {
        var refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshPatientList), for: .valueChanged)
        self.conversationtable?.refreshControl = refreshControl
    }
    
    @objc func refreshPatientList() {
        conversations = []
        self.conversationtable?.reloadData()
        getConversation()
    }
    

    @objc func showAddConversationViewModal() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let conversationVC = storyboard.instantiateViewController(withIdentifier: "AddConversationItemViewController") as! AddConversationItemViewController
        conversationVC.patientId = patientId
        conversationVC.doctorId = doctorId
        self.navigationController?.present(conversationVC, animated: true)
    }
    
    fileprivate func SetupTableView(){
        view.addSubview(conversationtable)
        conversationtable.register(ConversationCell.self, forCellReuseIdentifier: "cell")
        conversationtable.delegate = self
        conversationtable.dataSource = self
    }
    
    func getConversation() {
        conversationtable?.refreshControl?.beginRefreshing()
        NiZiAPIHelper.GetConversations(withToken: KeychainWrapper.standard.string(forKey: "authToken")!, withPatient: patientId).responseData(completionHandler: { response in
            
            guard let jsonResponse = response.data
                else { return }
            
            let jsonDecoder = JSONDecoder()
            guard let conversations = try? jsonDecoder.decode( [NewConversation].self, from: jsonResponse )
                else { return }
            
            self.conversations = conversations
            self.conversationtable?.reloadData()
            self.conversationtable?.refreshControl?.endRefreshing()
        })
    }
}

extension AddConversationViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedIndex == indexPath { return 150 }
        return 40
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
