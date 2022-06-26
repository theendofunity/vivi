//
//  ChatDetailsPresenter.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 15.06.2022.
//

import Foundation
import FirebaseFirestore

protocol ChatDetailViewType: AnyObject {
    func update(messages: [MessageModel])
    func showError(error: Error)
}

class ChatDetailsPresenter {
    weak var view: ChatDetailViewType?
    var chat: ChatModel
    var currentSender: UserModel
    
    var listener: ListenerRegistration?
    
    var storage = FirestoreService.shared
    
    init(chat: ChatModel, currentUser: UserModel) {
        self.chat = chat
        self.currentSender = currentUser
        
        listener = storage.addMessagesObserver(chatId: chat.id, completion: { [weak self] result in
            print("LISTENER")
            guard let self = self else { return }
            print(result)
            switch result {
            case .success(let messages):
                self.chat.messages = messages
                self.view?.update(messages: self.chat.messages)
            case .failure(let error):
                self.view?.showError(error: error)
            }
        })
       
    }
    
    deinit {
        listener?.remove()
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
