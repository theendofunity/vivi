//
//  ProjectDetailPresenter.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 05.06.2022.
//

import UIKit
import SwiftLoader

protocol ProjectDetailViewType: AnyObject {
    func setupMenu(items: [ProfileMenuType])
    func navigation() -> UINavigationController?
    func updateHeader(project: ProjectModel)
    func showError(error: Error)
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
        switch item {
        case .form:
            showForm()
        case .agreement:
            showAgreements()
        case .project:
            showProject()
        case .examples:
            showExamples()
        case .sketches:
            showSketches()
        case .visualizations:
            showVisualizations()
        case .users:
            showUsers()
        default:
            break
        }
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
    
    func showForm() {
        let view = TextMenuViewController()
        let presenter = FormPresenter(type: .form, project: project.title)
        view.presenter = presenter
        presenter.view = view
        
        self.view?.navigation()?.pushViewController(view, animated: true)
    }
    
    func showAgreements() {
        showTextMenu(type: .agreement)
    }
    
    func showProject() {
        showTextMenu(type: .project)
    }
    
    func showExamples() {
        showGalleryMenu(type: .examples)
    }
    
    func showSketches() {
        showGalleryMenu(type: .sketches)
    }
    
    func showVisualizations() {
        showGalleryMenu(type: .visualizations)
    }
    
    func showUsers() {
        let view = UsersViewController()
        let presenter = UsersPresenter()
        view.presenter = presenter
        presenter.view = view
        
        self.view?.navigation()?.pushViewController(view, animated: true)
    }
}

extension ProjectDetailPresenter {
    func setAvatar(image: UIImage) {
        guard let data = image.jpegData(compressionQuality: Constants.compressionQuality) else { return }
        
        SwiftLoader.show(animated: true)
        StorageService.shared.saveData(data: data, referenceType: .avatars) { [weak self] result in
            SwiftLoader.hide()
            guard let self = self else { return }
            switch result {
            case .success(let url):
                self.project.avatarUrl = url.absoluteString
                self.view?.updateHeader(project: self.project)
                self.saveProject()
            case .failure(let error):
                self.view?.showError(error: error)
            }
        }
    }
    
    func saveProject() {
        SwiftLoader.show(animated: true)
        FirestoreService.shared.save(reference: .projects, data: project) { [weak self] result in
            SwiftLoader.hide()
            switch result {
            case .success():
                break
            case .failure(let error):
                self?.view?.showError(error: error)
            }
        }
    }
}
