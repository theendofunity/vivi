//
//  ChatPresenter.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 02.05.2022.
//

import UIKit
import FirebaseFirestore
import SwiftLoader

protocol ChatViewType: AnyObject {
    func hideAddButton(isHidden: Bool)
    func showError(error: Error)
    func update(chats: [ChatModel])
    func navigation() -> UINavigationController?
}

class ChatsListPresenter {
    var view: ChatViewType?
    let storage = ChatService.shared
    var listener: ListenerRegistration?
    var chats: [ChatModel] = []
    
    deinit {
        listener = nil
    }
    
    func viewLoaded() {
        addListener()
    }
    
    func viewAppeared() {
        setupAddButton()
        
        checkChatsState()
    }
    
    func addListener() {
        listener = storage.addChatsObserver(completion: { [weak self] result in
            switch result {
            case .success(let chats):
                for newChat in chats {
                    if let index = self?.chats.firstIndex(where: { $0.id == newChat.id }) {
                        self?.chats[index] = newChat
                    } else {
                        self?.chats.append(newChat)
                    }
                }
                self?.reload()
                
                DataStore.shared.chats = chats
                
            case .failure(let error):
                self?.view?.showError(error: error)
            }
        })
    }
    
    func reload() {
        view?.update(chats: chats)
    }
    
    func setupAddButton() {
        var isButtonHidden = true
        
        if let user = UserService.shared.user {
            isButtonHidden = user.userType != .admin
        }
        
        view?.hideAddButton(isHidden: isButtonHidden)
    }
    
    func addButtonPressed() {
        let presenter = NewChatPresenter()
        let view = NewChatViewController()
        presenter.view = view
        presenter.delegate = self
        view.presenter = presenter
        self.view?.navigation()?.pushViewController(view, animated: true)
    }
    
    func chatDidSelected(chat: ChatModel) {
        guard let user = UserService.shared.user else { return }
        
        let presenter = ChatDetailsPresenter(chat: chat, currentUser: user)
        let view = ChatDetailViewController()
        presenter.view = view
        view.presenter = presenter
        
        self.view?.navigation()?.pushViewController(view, animated: true)
    }
}

extension ChatsListPresenter: NewChatDelegate {
    func usersSelected(users: [UserModel]) {
        view?.navigation()?.popViewController(animated: true)        
    }
}

extension ChatsListPresenter {
    func checkChatsState() {
        guard let user = UserService.shared.user,
        user.userType == .base
        else {
            return
        }
        
        if user.chats.isEmpty {
            startChatForNewUser()
        }
    }
    
    func startChatForNewUser() {
        SwiftLoader.show(title: "Создается час с администратором", animated: true)
        
        ChatService.shared.startChatWithAdmin { [weak self] result in
            SwiftLoader.hide()
            
            switch result {
            case .success():
                break
            case .failure(let error):
                self?.view?.showError(error: error)
            }
        }
    }
}
