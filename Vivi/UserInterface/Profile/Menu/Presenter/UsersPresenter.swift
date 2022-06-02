//
//  UsersPresenter.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 02.06.2022.
//

import Foundation
import SwiftLoader

protocol UsersViewType: AnyObject {
    func update(users: [UserModel])
    func showError(error: Error)
    func navigation() -> UINavigationController?
}

class UsersPresenter {
    weak var view: UsersViewType?
    var storage = FirestoreService.shared
    
    func viewLoaded() {
    }
    
    func viewAppeared() {
        loadData()
    }
    
    func loadData() {
        SwiftLoader.show(animated: true)
        
        storage.load(referenceType: .users) { [weak self] (result: Result<[UserModel], Error>) in
            SwiftLoader.hide()
            
            switch result {
            case .success(let users):
                let filtredUsers = users.filter { $0.userType != .admin }
                self?.view?.update(users: filtredUsers)
            case .failure(let error):
                self?.view?.showError(error: error)
            }
        }
    }
    
    func userDidSelect(_ user: UserModel) {
        let view = UserDetailViewController()
        let presenter = UserDetailPresenter(user: user)
        view.presenter = presenter
        presenter.view = view
        self.view?.navigation()?.pushViewController(view, animated: true)
    }
}

extension UsersPresenter: UsersDetailDelegate {
    func userUpdated() {
//        loadData()
    }
}
