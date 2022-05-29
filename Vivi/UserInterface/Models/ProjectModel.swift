//
//  ProjectModel.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 30.05.2022.
//

import Foundation

struct ProjectModel: FirestoreSavable {
    var title: String
    var address: String
    var users: [String] = []
    
    func representation() -> [String : Any] {
        var dict: [String : Any] = [:]
        dict = [
            "title" : title,
            "address" : address,
            "users" : users
        ]
        return dict
    }
    
    init?(document: [String : Any]) {
        guard let title = document["title"] as? String,
              let address = document["address"] as? String
        else { return nil }
        
        self.title = title
        self.address = address
        
        if let users = document["users"] as? [String] {
            self.users = users
        }
    }
    
    func documentId() -> String? {
        return title
    }
}
