//
//  AddConversationItemViewController.swift
//  NiziApp
//
//  Created by Patrick Dammers on 10/12/2020.
//  Copyright © 2020 Samir Yeasin. All rights reserved.
//

import Foundation
import UIKit
import SwiftKeychainWrapper

class AddConversationItemViewController : UIViewController
{
    @IBOutlet weak var popupTitle: UILabel!
    
    @IBOutlet weak var newConversationTitleLabel: UILabel!
    @IBOutlet weak var newConversationDescriptionLabel: UILabel!
    
    @IBOutlet weak var newConversationTitleField: UITextField!
    @IBOutlet weak var newConversationDescriptionField: UITextView!
    
    @IBOutlet weak var newConversationAddButton : UIButton!
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        return formatter
    }()
    
    var patientId : Int!
    var doctorId : Int!
    var listViewController : AddConversationViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLanguageSpecificText()
        newConversationDescriptionField.layer.cornerRadius = 5.0
        newConversationDescriptionField.layer.borderWidth = 2.0
        newConversationDescriptionField.layer.borderColor = UIColor.systemGray5.cgColor
    }
    
    func setLanguageSpecificText() {
        newConversationTitleLabel.text = NSLocalizedString("ConversationTitle", comment: "")
        newConversationDescriptionLabel.text = NSLocalizedString("ConversationDescription", comment: "")
        newConversationAddButton.setTitle(NSLocalizedString("AddConversation", comment: ""), for: .normal)
        
        popupTitle.text = NSLocalizedString("AddConversations", comment: "")
    }
    
    func requiredFieldsForNewConversationFilled() -> Bool {
        return (newConversationTitleField.text != "" && newConversationDescriptionField.text != "")
    }
    
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
    
    func showConversationAddedMessage() {
        self.newConversationTitleField.text = ""
        self.newConversationDescriptionField.text = ""
        
        DispatchQueue.main.async {
            let alertController = UIAlertController(
                title: NSLocalizedString("conversationAddedTitle", comment: ""),
                message: NSLocalizedString("conversationAddedMessage", comment: ""),
                preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "Ok"), style: .default, handler: { _ in
                self.listViewController.getConversation()
                self.dismiss(animated: true, completion: {})
            }))
            
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
