//
//  ChatModel.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 14.06.2022.
//

import UIKit

protocol ChatModelDelegate: AnyObject {
    func modelUpdated()
}

class ChatModel: FirestoreSavable {
    enum ChatType {
        case project
        case person
    }
    
    weak var delegate: ChatModelDelegate?
    
//    MARK: - stored
    var users: [String] = []
    var userNames: [String] = []
    var title: String = ""
    var id: String
    var lastMessage: MessageModel?
    
//    MARK: - Internal
    var avatarUrl: String?
    var type: ChatType = .person
    
    internal init(users: [String] = [], userNames: [String] = [], lastMessageContent: String? = nil, avatarUrl: String? = nil, title: String) {
        self.users = users
        self.avatarUrl = avatarUrl
        self.title = title
        self.id = UUID().uuidString
        self.userNames = userNames
    }
    
    required init?(document: [String : Any]) {
        guard let users = document["users"] as? [String],
              let id = document["id"] as? String
        else { return nil }
        
        self.users = users
        self.id = id
        
        title = document["title"] as? String ?? ""
        
        if let userNames = document["userNames"] as? [String] {
            self.userNames = userNames
        }
        
        let messageContent = document["lastMessage"] as? [String : Any] ?? [:]
        lastMessage = MessageModel(document: messageContent)
        
        if title.isEmpty,
           users.count == 2 {
            type = .person
        } else {
            type = .project
        }
        
        updateAvatars()
    }
    
    func documentId() -> String? {
        return id
    }
    
    func representation() -> [String : Any] {
        let dict: [String : Any] = [
            "users" : users,
            "id" : id,
            "title" : title,
            "userNames" : userNames,
            "lastMessage" : lastMessage?.representation() ?? [:]
        ]
        
        return dict
    }
    
    func displayTitle() -> String {
        if title.isEmpty {
            return userNames.first(where: { $0 != UserService.shared.user?.displayName }) ?? ""
        }
        
        return title
    }
    
    func isEqualTo(chat: ChatModel) -> Bool {
        return displayTitle() == chat.displayTitle() &&
        users == chat.users
    }
    
    func updateAvatars() {
        AvatarsService.shared.getAvatarUrl(for: self) { [weak self] url in
            self?.avatarUrl = url
            self?.delegate?.modelUpdated()
        }
    }
}

extension ChatModel: Hashable {
    static func == (lhs: ChatModel, rhs: ChatModel) -> Bool {
        lhs.id == rhs.id && lhs.title == rhs.title && lhs.users == rhs.users
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
}
