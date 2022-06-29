//
//  AddNewProjectPresenter.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 31.05.2022.
//

import Foundation

protocol NewProjectViewType: AnyObject {
    func setupFields(fields: [TextFieldViewModel])
    func showError(error: Error)
    func showSuccess()
}

protocol NewProjectDelegate: AnyObject {
    func projectAdded(_ project: ProjectModel)
}

class NewProjectPresenter {
    weak var view: NewProjectViewType?
    weak var delegate: NewProjectDelegate?
    
    func viewDidLoad() {
        setupFields()
    }
    
    func setupFields() {
        let fields: [TextFieldViewModel] = [
            .init(type: .title, value: ""),
            .init(type: .address, value: ""),
            .init(type: .square, value: ""),
            .init(type: .type, value: "")
        ]
        
        view?.setupFields(fields: fields)
    }
    
    
    func save(project: ProjectModel) {        
        FirestoreService.shared.save(reference: .projects, data: project) { [weak self] result in
            switch result {
            case .success():
                self?.delegate?.projectAdded(project)
                self?.view?.showSuccess()
            case .failure(let error):
                self?.view?.showError(error: error)
            }
        }
    }
}
