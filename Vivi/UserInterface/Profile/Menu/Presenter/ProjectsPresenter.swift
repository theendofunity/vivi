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
    func projectsDidSelect(projects: [ProjectModel])
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
    var storage = FirestoreService.shared
    var projects: [ProjectModel] = []
    var selectedProjects: [ProjectModel] = []
    
    init(type: ViewType = .details, selectionType: SelectionType = .single) {
        self.type = type
        self.selectionType = selectionType
    }
    
    func viewDidLoad() {
        view?.setupTitle("Проекты")
        
        if type == .select {
            let title = selectionType == .single ? "Создать новый" : "Cохранить"
            view?.setupButton(title: title, isHidden: false)
        } else {
            view?.setupButton(title: "", isHidden: true)
        }
    }
    
    func viewDidAppear() {
        SwiftLoader.show(animated: true)
        loadData()
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
        delegate?.projectsDidSelect(projects: selectedProjects)
    }
    
    func fileDidSelect(filename: String) {
        if type == .select {
            if selectionType == .single {
                guard let project = projects.first(where: { $0.title == filename }) else { return }
                delegate?.projectsDidSelect(projects: [project])
            } else {
                guard let index = projects.firstIndex(where: {$0.title == filename}) else { return }
                view?.selectCell(indexPath: IndexPath(item: index, section: 0))
                
                let project = projects[index]
                if selectedProjects.contains(where: {$0.title == project.title}) {
                    selectedProjects.remove(at: index)
                } else {
                    selectedProjects.append(project)
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
