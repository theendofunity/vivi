//
//  ProjectsPresenter.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 31.05.2022.
//

import Foundation
import SwiftLoader
import SwiftLoader

class ProjectsPresenter: TextMenuPresenterProtocol {
    weak var view: TextMenuViewType?
    var storage = FirestoreService.shared
    var projects: [ProjectModel] = []
    
    func viewDidLoad() {
        view?.setupTitle("Проекты")
        view?.setupButton(title: "Создать новый", isHidden: false)
    }
    
    func viewDidAppear() {
        SwiftLoader.show(animated: true)
        loadData()
    }
    
    func buttonPressed() {
        let presenter = NewProjectPresenter()
        let view = NewProjectViewController()
        presenter.view = view
        presenter.delegate = self
        view.presnter = presenter
        self.view?.navigation()?.present(view, animated: true)
    }
    
    func fileDidSelect(filename: String) {
        
    }
    
    func loadData() {
        storage.load(referenceType: .projects) { [weak self] (result: Result<[ProjectModel], Error>) in
            SwiftLoader.hide()
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.projects = data
                self.updateView()
            case .failure(let error):
                self.view?.showError(error: error)
            }
        }
    }
    
    func updateView() {
        self.view?.setupFiles(files: projects.map({ $0.title }))
    }
    
    func add(file: Any) {
        
    }
    
    
}

extension ProjectsPresenter: NewProjectDelegate {
    func projectAdded(_ project: ProjectModel) {
        projects.append(project)
        updateView()
    }
}
