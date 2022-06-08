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
    func navigation() -> UINavigationController?
}

class ChatPresenter {
    var view: ChatViewType?
    
    func viewLoaded() {
    
    }
    
    func viewAppeared() {
        setupAddButton()
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
        view.presenter = presenter
        self.view?.navigation()?.pushViewController(view, animated: true)
    }
}
