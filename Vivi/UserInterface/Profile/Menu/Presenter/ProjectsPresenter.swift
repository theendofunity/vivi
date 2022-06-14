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
    func projectDidSelect(project: ProjectModel)
}

class ProjectsPresenter: TextMenuPresenterProtocol {
    enum ViewType {
        case details
        case select
    }
    
    weak var view: TextMenuViewType?
    weak var delegate: ProjectPresenterDelegate?
    
    var type: ViewType
    var storage = FirestoreService.shared
    var projects: [ProjectModel] = []
    
    init(type: ViewType = .details) {
        self.type = type
    }
    
    func viewDidLoad() {
        view?.setupTitle("Проекты")
        
        let isButtonHidden = type == .select
        view?.setupButton(title: "Создать новый", isHidden: isButtonHidden)
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
        if type == .select {
            guard let project = projects.first(where: { $0.title == filename }) else { return }
            delegate?.projectDidSelect(project: project)
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
