//
//  ProjectsPresenter.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 31.05.2022.
//

import Foundation
import SwiftLoader
import SwiftLoader

protocol ProjectPresenterDelegate: AnyObject {
    func projectsUpdated(selectedProjects: [ProjectModel], allProjects: [ProjectModel])
}

class ProjectsPresenter: TextMenuPresenterProtocol {
    enum ViewType {
        case details
        case select
    }
    
    enum SelectionType {
        case single
        case multiply
    }
    
    weak var view: TextMenuViewType?
    weak var delegate: ProjectPresenterDelegate?
    
    var type: ViewType
    var selectionType: SelectionType
    var user: UserModel
    var storage = FirestoreService.shared
    var projects: [ProjectModel] = []
    var selectedProjects: [String : ProjectModel] = [:]
    
    init(type: ViewType = .details, selectionType: SelectionType = .single, user: UserModel) {
        self.type = type
        self.selectionType = selectionType
        self.user = user
    }
    
    func viewDidLoad() {
        view?.setupTitle("Проекты")
        
       setupButton()
    }
    
    func viewDidAppear() {
        SwiftLoader.show(animated: true)
        loadData()
    }
    
    func setupButton() {
        if type == .select {
            if selectionType == .single {
                view?.setupButton(title: "", isHidden: true)
            } else {
                view?.setupButton(title: "Cохранить", isHidden: false)
            }
        } else {
            if let user = UserService.shared.user,
               user.userType == .admin {
                view?.setupButton(title: "Создать новый", isHidden: false)
            }
        }
    }
    
    func buttonPressed() {
        switch selectionType {
        case .single:
            newProjectButtonPressed()
        case .multiply:
            saveButtonPressed()
        }
    }
    
    func newProjectButtonPressed() {
        let presenter = NewProjectPresenter()
        let view = NewProjectViewController()
        presenter.view = view
        presenter.delegate = self
        view.presnter = presenter
        self.view?.navigation()?.present(view, animated: true)
    }
    
    func saveButtonPressed() {
        delegate?.projectsUpdated(selectedProjects: Array(selectedProjects.values), allProjects: projects)
    }
    
    func fileDidSelect(filename: String) {
        if type == .select {
            if selectionType == .single {
                guard let project = projects.first(where: { $0.title == filename }) else { return }
                delegate?.projectsUpdated(selectedProjects: [project], allProjects: projects)
            } else {
                guard let index = projects.firstIndex(where: {$0.title == filename}) else { return }
                view?.selectCell(indexPath: IndexPath(item: index, section: 0))
                
                if selectedProjects[filename] == nil {
                    selectedProjects[filename] = projects[index]
                } else {
                    selectedProjects[filename] = nil
                }
            }
        } else if type == .details {
            showProject(filename)
        }
    }
    
    func showProject(_ name: String) {
        guard let project = projects.first(where: {
            $0.title == name
        }) else { return }
        
        let presenter = ProjectDetailPresenter(project: project)
        let view = ProjectDetailViewController()
        presenter.view = view
        view.presenter = presenter
        
        self.view?.navigation()?.pushViewController(view, animated: true)
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
        checkSelectedProjects()
        self.view?.setupFiles(files: projects.map({ $0.title }))
    }
    
    func checkSelectedProjects() {
        for (index, project) in projects.enumerated() {
            let indexPath = IndexPath(item: index, section: 0)
            
            if user.projects.contains(where: { projectName in
                projectName == project.title
            }) {
                view?.selectCell(indexPath: indexPath)
                self.selectedProjects[project.title] = project
            }
        }
    }
    
    func add(file: Any) {
        
    }
    
    func isCellSelected(indexPath: IndexPath) -> Bool {
        let project = projects[indexPath.item]
        
        return selectedProjects[project.title] != nil
    }
}

extension ProjectsPresenter: NewProjectDelegate {
    func projectAdded(_ project: ProjectModel) {
        projects.append(project)
        updateView()
    }
}
