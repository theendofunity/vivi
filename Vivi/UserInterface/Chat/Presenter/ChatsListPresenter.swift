//
//  ChatPresenter.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 02.05.2022.
//

import Foundation
import UIKit

protocol ChatViewType: AnyObject {
    func hideAddButton(isHidden: Bool)
    func showError(error: Error)
    func update(chats: [ChatModel])
    func navigation() -> UINavigationController?
}

class ChatsListPresenter {
    var view: ChatViewType?
    let storage = FirestoreService.shared
    
    var chats: [ChatModel] = []
    
    func viewLoaded() {
        loadChats()
    }
    
    func viewAppeared() {
        setupAddButton()
    }
    
    func loadChats() {
        storage.loadChats { [weak self] result in
            print(result)
            switch result {
            case .success(let chats):
                self?.chats = chats
                self?.view?.update(chats: chats)
            case .failure(let error):
                self?.view?.showError(error: error)
            }
        }
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
        
        print(users)
    }
}
