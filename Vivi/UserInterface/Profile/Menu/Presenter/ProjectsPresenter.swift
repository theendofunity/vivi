//
//  ProjectsPresenter.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 31.05.2022.
//

import Foundation

class ProjectsPresenter: TextMenuPresenterProtocol {
    weak var view: TextMenuViewType?
    var storage = FirestoreService.shared
    var projects: [ProjectModel] = []
    
    func viewDidLoad() {
        view?.setupTitle("Проекты")
        view?.setupButton(title: "Создать новый", isHidden: false)
        loadData()
    }
    
    func viewDidAppear() {
    }
    
    func buttonPressed() {
        let presenter = NewProjectPresenter()
        let view = NewProjectViewController()
        presenter.view = view
        view.presnter = presenter
        self.view?.navigation()?.present(view, animated: true)
    }
    
    func fileDidSelect(filename: String) {
        
    }
    
    func loadData() {
        storage.load(referenceType: .projects) { [weak self] (result: Result<[ProjectModel], Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.projects = data
                self.view?.setupFiles(files: data.map({ $0.title }))
            case .failure(let error):
                self.view?.showError(error: error)
            }
        }
    }
    
    func add(file: Any) {
        
    }
    
    
}
