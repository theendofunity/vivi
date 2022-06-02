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
        let model = TextFieldViewModel(type: .project, value: user.project ?? "", canEdit: false)
        view?.setupProject(model: model)
    }
    
    func saveButtonPressed(project: String, userType: UserType) {
        user.userType = userType
        user.project = project
        
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
    
    func writeButtonPressed() {
        
    }
    
    func changeProjectButtonPressed() {
        let view = TextMenuViewController()
        let presenter = ProjectsPresenter(type: .select)
        presenter.delegate = self
        view.presenter = presenter
        presenter.view = view
        
        self.view?.navigation()?.present(view, animated: true)
    }
}

extension UserDetailPresenter: ProjectPresenterDelegate {
    func projectDidSelect(name: String) {
        view?.navigation()?.dismiss(animated: true)
        
        user.project = name
        setupProject()
    }
}
