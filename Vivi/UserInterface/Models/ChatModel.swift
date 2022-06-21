//
//  ChatModel.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 14.06.2022.
//

import Foundation

struct ChatModel: FirestoreSavable {
    var users: [String] = []
    var messages: [MessageModel] = []
    var avatarUrl: String?
    var title: String = ""
    
    internal init(users: [String] = [], messages: [MessageModel] = [], avatarUrl: String? = nil, title: String) {
        self.users = users
        self.messages = messages
        self.avatarUrl = avatarUrl
        self.title = title
    }
    
    init?(document: [String : Any]) {
        guard let users = document["users"] as? [String]
        else { return nil }
        
        self.avatarUrl = document["avatarUrl"] as? String
        self.users = users
//        self.title = title
        
        if let messages = document["messages"] as? [MessageModel] {
            self.messages = messages
        }
        
    }
    
    
    func documentId() -> String? {
        return "id"
    }
    
    func representation() -> [String : Any] {
        let dict: [String : Any] = [
            "users" : users,
            "messages" : messages
        ]
        //TODO: ADD OTHER FIELDS
        
        return dict
    }
}

extension ChatModel: Hashable {
    static func == (lhs: ChatModel, rhs: ChatModel) -> Bool {
        lhs.title == rhs.title
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
}
