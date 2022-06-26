//
//  NewChatPresenter.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 09.06.2022.
//

import Foundation
import SwiftLoader

protocol NewChatViewType: AnyObject {
    func setup(users: [UserModel])
    func setup(projects: [ProjectModel])
    func showError(error: Error)
}

protocol NewChatDelegate: AnyObject {
    func usersSelected(users: [UserModel])
}

class NewChatPresenter {
    weak var view: NewChatViewType?
    weak var delegate: NewChatDelegate?
    var users: [UserModel] = []
    var storage = FirestoreService.shared
    
    func viewDidLoad() {
        loadData()
    }
    
    func viewDidAppear() {
        
    }
    
    func loadData() {
        let group = DispatchGroup()
        
        SwiftLoader.show(animated: true)
        
        loadUsers(group: group)
        loadProjects(group: group)
        
        group.notify(queue: .main) {
            SwiftLoader.hide()
        }
    }
    
    func loadUsers(group: DispatchGroup) {
        group.enter()
        storage.load(referenceType: .users) { [weak self] (result: Result<[UserModel], Error>) in
            group.leave()
            switch result {
            case .success(let users):
                guard let id = UserService.shared.user?.id else { return }
                let filtredUsers = users.filter {
                    $0.id != id
                }
                self?.users = filtredUsers
                self?.view?.setup(users: filtredUsers)
            case .failure(let error):
                self?.view?.showError(error: error)
            }
        }
    }
    
    func loadProjects(group: DispatchGroup) {
        group.enter()
        storage.load(referenceType: .projects) { [weak self] (result: Result<[ProjectModel], Error>) in
            group.leave()
            switch result {
            case .success(let projects):
                self?.view?.setup(projects: projects)
            case .failure(let error):
                self?.view?.showError(error: error)
            }
        }
    }
    
    func userDidSelect(user: UserModel) {
        guard let currentId = AuthService.shared.currentUser?.uid,
              let destinationId = user.id
        else {
            return
        }
        let selfChat = ChatModel(users: [currentId, destinationId], title: "")
        
        storage.save(reference: .chats, data: selfChat) { [weak self] result in
            self?.delegate?.usersSelected(users: [user])
        }
    }
    
    func projectDidSelect(project: ProjectModel) {
        print(project.title, project.users)
        let usersInProject = users.filter { user in
            return project.users.contains { $0 == user.id}
        }
        
        delegate?.usersSelected(users: usersInProject)
    }
}
