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
    func setTitle(title: String)
}

class ChatDetailsPresenter {
    weak var view: ChatDetailViewType?
    
    var chat: ChatModel
    var messages: [MessageModel] = []
    var currentSender: UserModel
    
    var listener: ListenerRegistration?
    var storage = FirestoreService.shared
    
    init(chat: ChatModel, currentUser: UserModel) {
        self.chat = chat
        self.currentSender = currentUser
    }
    
    deinit {
        listener?.remove()
    }
    
     func viewDidLoad() {
         addListener()
         setTitle()
    }
    
    func viewDidAppear() {
        
    }
    
    func addListener() {
        listener = storage.addMessagesObserver(chatId: chat.id, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let messages):
                let filtredMessages = messages.filter { newMessage in
                    !self.messages.contains(where: { oldMessage in
                        oldMessage.id == newMessage.id
                    })
                } .sorted { $0.sentDate < $1.sentDate }
                
                self.messages.append(contentsOf: filtredMessages)
                self.view?.update(messages: self.messages)
            case .failure(let error):
                self.view?.showError(error: error)
            }
        })
    }
    
    func setTitle() {
        guard chat.title.isEmpty else {
            view?.setTitle(title: chat.title)
            return
        }
        
        guard let userId = chat.users.first(where: { $0 != currentSender.id }) else { return }
        
        storage.loadUser(userId: userId) { [weak self] result in
            switch result {
            case .success(let user):
                self?.view?.setTitle(title: user.displayName)
            default:
                break
            }
        }
    }
}

extension ChatDetailsPresenter {
    func sendMessage(text: String) {
        var message = MessageModel(sender: currentSender, content: text)
        message.avatarUrl = currentSender.avatarUrl
        
//        view?.update(messages: messages)
        
        chat.lastMessageContent = text
        
        storage.sendMessage(chat: chat, message: message) { [weak self] result in
            switch result {
            case .success():
                break
            case .failure(let error):
                self?.view?.showError(error: error)
            }
        }
    }
}
