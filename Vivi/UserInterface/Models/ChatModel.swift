//
//  ChatModel.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 14.06.2022.
//

import Foundation

struct ChatModel: FirestoreSavable {
    internal init(users: [String] = []) {
        self.users = users
    }
    
    var users: [String] = []
    
    init?(document: [String : Any]) {
        guard let users = document["users"] as? [String]
        else { return nil }
        
        self.users = users
    }
    
    
    func documentId() -> String? {
        return "id"
    }
    
    func representation() -> [String : Any] {
        let dict: [String : Any] = [
            "users" : users
        ]
        
        return dict
    }
    
    
}
