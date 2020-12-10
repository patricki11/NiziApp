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
    
    @IBOutlet weak var newConversationTitleField: UITextField!
    @IBOutlet weak var newConversationDescriptionField: UITextField!
    
    @IBOutlet weak var newConversationTitleLabel: UILabel!
    @IBOutlet weak var newConversationDescriptionLabel: UILabel!
    
    @IBOutlet weak var newConversationAddButton : UIButton!
    
    @IBAction func createNewConversation(_ sender: Any) {
        
        if(requiredFieldsForNewConversationFilled()) {
            
            var title = newConversationTitleField.text ?? ""
            var description = newConversationDescriptionField.text ?? ""
            
            let newConversation = NewConversation(
                id : 0,
                title : title,
                comment: description,
                date: dateFormatter.string(from: Date()),
                isRead : false,
                doctor : nil,
                doctorId: doctorId,
                patient : nil,
                patientId: patientId)
            
            NiZiAPIHelper.createConversation(withDetails: newConversation, authorization: KeychainWrapper.standard.string(forKey: "authToken")!).responseData(completionHandler: { response in
                
                self.showConversationAddedMessage()
            })
        }
        else {
            showRequiredFieldsNotFilledMessage()
        }
    }
    
    func requiredFieldsForNewConversationFilled() -> Bool {
        return (newConversationTitleField.text != "" && newConversationDescriptionField.text != "")
    }
    
    @IBOutlet weak var conversationtable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Conversations", comment: "")
        setLanguageSpecificText()
        getConversation()
        SetupTableView()
    }
    
    func setLanguageSpecificText() {
        newConversationTitleLabel.text = NSLocalizedString("ConversationTitle", comment: "")
        newConversationDescriptionLabel.text = NSLocalizedString("ConversationDescription", comment: "")
        newConversationAddButton.setTitle(NSLocalizedString("AddConversation", comment: ""), for: .normal)
    }

    fileprivate func SetupTableView(){
        view.addSubview(conversationtable)
        conversationtable.register(ConversationCell.self, forCellReuseIdentifier: "cell")
        conversationtable.delegate = self
        conversationtable.dataSource = self
    }
    
    func getConversation() {
        NiZiAPIHelper.GetConversations(withToken: KeychainWrapper.standard.string(forKey: "authToken")!, withPatient: patientId).responseData(completionHandler: { response in
            
            guard let jsonResponse = response.data
                else { return }
            
            let jsonDecoder = JSONDecoder()
            guard let conversations = try? jsonDecoder.decode( [NewConversation].self, from: jsonResponse )
                else { return }
            
            self.conversations = conversations
            self.conversationtable?.reloadData()
        })
    }
    
    func showConversationAddedMessage() {
        self.newConversationTitleField.text = ""
        self.newConversationDescriptionField.text = ""
        
        DispatchQueue.main.async {
            let alertController = UIAlertController(
                title: NSLocalizedString("conversationAddedTitle", comment: ""),
                message: NSLocalizedString("conversationAddedMessage", comment: ""),
                preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "Ok"), style: .default, handler: { _ in self.getConversation()}))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func showRequiredFieldsNotFilledMessage() {
        self.newConversationTitleField.text = ""
        self.newConversationDescriptionField.text = ""
        
        DispatchQueue.main.async {
            let alertController = UIAlertController(
                title: NSLocalizedString("requiredFieldsTitle", comment: ""),
                message: NSLocalizedString("requiredFieldsMessage", comment: ""),
                preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "Ok"), style: .default, handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
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
