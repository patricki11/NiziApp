//
//  ConversationCell.swift
//  NiziApp
//
//  Created by Samir Yeasin on 23/11/2020.
//  Copyright © 2020 Samir Yeasin. All rights reserved.
//

import UIKit

class ConversationCell : UITableViewCell{
    var data : NewConversation? {
        didSet{
            guard let data = data else {return}
            self.title.text = data.title
            self.url.text = data.comment
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ss.SSS'Z'"
            let date = dateFormatter.date(from:data.date!)
            dateFormatter.dateFormat = "dd MMMM YYYY"
            let dateString = dateFormatter.string(from: date!)
            self.dateAdded.text = dateString
        }
    }
    
    func animate() {
        UIView.animate(withDuration: 0.5, delay: 0.3, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.contentView.layoutIfNeeded()
        })
    }
    
    fileprivate let title : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.text = "hmm course title here"
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate let url : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.text = "hmm course URL here"
        label.textColor = .black
        label.numberOfLines = -1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate let dateAdded : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.text = "date"
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate let container : UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.clipsToBounds = true
        v.backgroundColor = UIColor.white
        v.layer.cornerRadius = 8
        return v
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(container)
        container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4).isActive = true
        container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4).isActive = true
        container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4).isActive = true
        container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4).isActive = true
        
        container.addSubview(dateAdded)
        container.addSubview(title)
        container.addSubview(url)
        
        dateAdded.topAnchor.constraint(equalTo: container.topAnchor, constant: 5).isActive = true
        dateAdded.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10).isActive = true
        dateAdded.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        title.topAnchor.constraint(equalTo: container.topAnchor, constant: 5).isActive = true
        title.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 4).isActive = true
        title.trailingAnchor.constraint(equalTo: dateAdded.trailingAnchor, constant: -4).isActive = true
        title.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        url.topAnchor.constraint(equalTo: dateAdded.bottomAnchor, constant: 5).isActive = true
        url.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 4).isActive = true
        url.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -4).isActive = true
        url.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
