//
//  UserDetailPresenter.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 03.06.2022.
//

import UIKit
import SwiftLoader

protocol UserDetailViewType: AnyObject {
    func setupHeader(user: UserModel)
    func setupProject(model: TextFieldViewModel)
    func showError(error: Error)
    func showSuccess()
    func navigation() -> UINavigationController?
}

protocol UsersDetailDelegate: AnyObject {
    func userUpdated()
}

class UserDetailPresenter {
    weak var view: UserDetailViewType?
    weak var delegate: UsersDetailDelegate?
    var user: UserModel
    var storage = FirestoreService.shared
    
    var selectedProjects: [ProjectModel] = []
    var allProjects: [ProjectModel] = []
    
    init(user: UserModel) {
        self.user = user
    }
    
    func viewLoaded() {
        view?.setupHeader(user: user)
        setupProject()
    }
    
    func viewAppeared() {
        
    }
    
    func setupProject() {
        var projectTitle = user.projects.first ?? ""
        if let selectedProject = selectedProjects.first {
            projectTitle = selectedProject.title
            if selectedProjects.count > 1 {
                projectTitle.append(" ...")
            }
        }
        
        let model = TextFieldViewModel(type: .project, value: projectTitle, canEdit: false)
        view?.setupProject(model: model)
    }
    
    func saveButtonPressed(userType: UserType) {
        addUserToProject()
        
        user.projects = selectedProjects.map({ $0.title })

        user.userType = userType
        
        SwiftLoader.show(animated: true)
        storage.save(reference: .users, data: user) { [weak self] result in
            SwiftLoader.hide()
            switch result {
            case .success():
                self?.view?.showSuccess()
                self?.delegate?.userUpdated()
            case .failure(let error):
                self?.view?.showError(error: error)
            }
        }
    }
    
    func addUserToProject() {
        //add to project
        for (index, project) in selectedProjects.enumerated() {
            var changableProject = project
            changableProject.users.append(user.id)
            storage.updateUsersInProject(project: changableProject)
            
            selectedProjects[index] = changableProject
        }
        
        //remove from project
        for (index, project) in allProjects.enumerated() {
            if selectedProjects.contains(where: { $0.documentId() == project.documentId() }) {
                continue
            }
            
            if let userIndex = project.users.firstIndex(where: { $0 == user.id }) {
                var changableProject = project
                changableProject.users.remove(at: userIndex)
                storage.removeUsersFromProject(project: project, users: [user.id])
                allProjects[index] = changableProject
            }
        }
    }
    
    func writeButtonPressed() {
        
    }
    
    func changeProjectButtonPressed() {
        let view = TextMenuViewController()
        let presenter = ProjectsPresenter(type: .select, selectionType: .multiply, user: user)
        presenter.delegate = self
        view.presenter = presenter
        presenter.view = view
        
        self.view?.navigation()?.present(view, animated: true)
    }
}

extension UserDetailPresenter: ProjectPresenterDelegate {
    func projectsUpdated(selectedProjects: [ProjectModel], allProjects: [ProjectModel]) {
        view?.navigation()?.dismiss(animated: true)
        
        self.selectedProjects = selectedProjects
        self.allProjects = allProjects
        setupProject()
    }
}
