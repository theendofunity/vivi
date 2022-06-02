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
}

class UsersPresenter {
    weak var view: UsersViewType?
    var storage = FirestoreService.shared
    
    func viewLoaded() {
        loadData()
    }
    
    func viewAppeared() {
        
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
}
