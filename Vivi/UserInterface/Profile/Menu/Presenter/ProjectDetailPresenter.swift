//
//  ProjectDetailPresenter.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 05.06.2022.
//

import UIKit

protocol ProjectDetailViewType: AnyObject {
    func setupMenu(items: [ProfileMenuType])
    func navigation() -> UINavigationController?
    func updateHeader(project: ProjectModel)
}

class ProjectDetailPresenter {
    var project: ProjectModel
    weak var view: ProjectDetailViewType?
    
    init(project: ProjectModel) {
        self.project = project
    }
    
    func viewLoaded() {
        setupMenu()
        setupHeader()
    }
    
    func viewAppeared() {
        
    }
    
    func setupMenu() {
        let menuItems: [ProfileMenuType] = [
            .form,
            .agreement,
            .examples,
            .sketches,
            .visualizations,
            .project,
            .users
        ]
        
        view?.setupMenu(items: menuItems)
    }
    
    func setupHeader() {
        view?.updateHeader(project: project)
    }
    
    func changeButtonPressed() {
        
    }
}

extension ProjectDetailPresenter {
    func menuItemDidSelect(item: ProfileMenuType) {
        
    }
    
    func showTextMenu(type: ProfileMenuType) {
        let view = TextMenuViewController()
        let presenter = TextMenuPresenter(type: type, project: project.title)
        view.presenter = presenter
        presenter.view = view
        
        self.view?.navigation()?.pushViewController(view, animated: true)
    }
    
    func showGalleryMenu(type: ProfileMenuType) {
        let view = PhotoGalleryViewController()
        let presenter = PhotoGalleryPresenter(type: type, project: project.title)
        view.presenter = presenter
        presenter.view = view
        
        self.view?.navigation()?.pushViewController(view, animated: true)
    }
}
