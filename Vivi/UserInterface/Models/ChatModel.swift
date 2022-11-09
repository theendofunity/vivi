//
//  ChatModel.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 14.06.2022.
//

import Foundation

struct ChatModel: FirestoreSavable {
    var users: [String] = []
    var userNames: [String] = []
    var avatarUrl: String?
    var title: String = ""
    var id: String
    var lastMessageContent: String? = nil
    
    internal init(users: [String] = [], userNames: [String] = [], lastMessageContent: String? = nil, avatarUrl: String? = nil, title: String) {
        self.users = users
        self.avatarUrl = avatarUrl
        self.title = title
        self.id = UUID().uuidString
        self.lastMessageContent = lastMessageContent
        self.userNames = userNames
    }
    
    init?(document: [String : Any]) {
        guard let users = document["users"] as? [String],
              let id = document["id"] as? String
        else { return nil }
        
        self.avatarUrl = document["avatarUrl"] as? String
        self.users = users
        self.id = id
        
        if let lastMessageContent = document["lastMessageContent"] as? String {
            self.lastMessageContent = lastMessageContent
        }
        
        title = document["title"] as? String ?? ""
        
        if let userNames = document["userNames"] as? [String] {
            self.userNames = userNames
        }
    }
    
    func documentId() -> String? {
        return id
    }
    
    func representation() -> [String : Any] {
        let dict: [String : Any] = [
            "users" : users,
            "id" : id,
            "title" : title,
            "lastMessageContent": lastMessageContent ?? "",
            "userNames" : userNames
        ]
        
        return dict
    }
    
    func displayTitle() -> String {
        if title.isEmpty {
            return userNames.first(where: { $0 != UserService.shared.user?.displayName }) ?? ""
        }
        
        return title
    }
}

extension ChatModel: Hashable {
    static func == (lhs: ChatModel, rhs: ChatModel) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
}
