//
//  NewChatPresenter.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 09.06.2022.
//

import Foundation

protocol NewChatViewType: AnyObject {
    func setup(users: [UserModel])
    func setup(projects: [ProjectModel])
    func showError(error: Error)
}

class NewChatPresenter {
    weak var view: NewChatViewType?
    var storage = FirestoreService.shared
    
    func viewDidLoad() {
        loadUsers()
        loadProjects()
    }
    
    func viewDidAppear() {
        
    }
    
    func loadUsers() {
        storage.load(referenceType: .users) { [weak self] (result: Result<[UserModel], Error>) in
            switch result {
            case .success(let users):
                self?.view?.setup(users: users)
            case .failure(let error):
                self?.view?.showError(error: error)
            }
        }
    }
    
    func loadProjects() {
        storage.load(referenceType: .projects) { [weak self] (result: Result<[ProjectModel], Error>) in
            switch result {
            case .success(let projects):
                self?.view?.setup(projects: projects)
            case .failure(let error):
                self?.view?.showError(error: error)
            }
        }
    }
}
