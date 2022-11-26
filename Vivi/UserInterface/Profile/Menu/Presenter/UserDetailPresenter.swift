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
        for (index, project) in selectedProjects.enumerated() {
            var changableProject = project
            changableProject.users.append(user.id)
            user.projects.append(changableProject.title)
            storage.updateUsersInProject(project: changableProject)
            
            selectedProjects[index] = changableProject
        }
    }
    
    func writeButtonPressed() {
        
    }
    
    func changeProjectButtonPressed() {
        let view = TextMenuViewController()
        let presenter = ProjectsPresenter(type: .select, selectionType: .multiply)
        presenter.delegate = self
        view.presenter = presenter
        presenter.view = view
        
        self.view?.navigation()?.present(view, animated: true)
    }
}

extension UserDetailPresenter: ProjectPresenterDelegate {
    func projectsDidSelect(projects: [ProjectModel]) {
        view?.navigation()?.dismiss(animated: true)
        
        selectedProjects = projects
        setupProject()
    }
}
