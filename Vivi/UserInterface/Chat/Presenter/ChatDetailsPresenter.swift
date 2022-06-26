//
//  ChatDetailsPresenter.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 15.06.2022.
//

import Foundation

protocol ChatDetailViewType: AnyObject {
    func update(messages: [MessageModel])
}

class ChatDetailsPresenter {
    weak var view: ChatDetailViewType?
    var chat: ChatModel
    var currentSender: UserModel
    
    var storage = FirestoreService.shared
    
    init(chat: ChatModel, currentUser: UserModel) {
        self.chat = chat
        self.currentSender = currentUser
    }
    
    func viewDidLoad() {
        view?.update(messages: chat.messages)
    }
    
    func viewDidAppear() {
        
    }
}

extension ChatDetailsPresenter {
    func sendMessage(text: String) {
        let message = MessageModel(sender: currentSender, content: text)
        chat.messages.append(message)
        view?.update(messages: chat.messages)
        
        storage.save(reference: .chats, data: chat) { result in
            print(#function, result)
        }
    }
}
