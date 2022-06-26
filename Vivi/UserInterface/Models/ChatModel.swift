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
    var id: String
    
    internal init(users: [String] = [], messages: [MessageModel] = [], avatarUrl: String? = nil, title: String) {
        self.users = users
        self.messages = messages
        self.avatarUrl = avatarUrl
        self.title = title
        self.id = UUID().uuidString
    }
    
    init?(document: [String : Any]) {
        guard let users = document["users"] as? [String],
              let id = document["id"] as? String
        else { return nil }
        
        self.avatarUrl = document["avatarUrl"] as? String
        self.users = users
        self.id = id
        
        if let messages = document["messages"] as? [[String : Any]] {
            for message in messages {
                if let newMessage = MessageModel(document: message) {
                    self.messages.append(newMessage)
                }
            }
        }
        
        if let title = document["title"] as? String {
            self.title = title
        }
    }
    
    func documentId() -> String? {
        return id
    }
    
    func representation() -> [String : Any] {
        var dict: [String : Any] = [
            "users" : users,
            "id" : id,
            "title" : title
        ]
        if !messages.isEmpty {
            dict["messages"] = messages.map({ $0.representation() })
        }
        
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
