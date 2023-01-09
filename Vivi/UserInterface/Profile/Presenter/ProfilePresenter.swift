//
//  ProfilePagerPresenter.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 16.05.2022.
//

import Foundation
import UIKit
import SwiftLoader

enum PageType: String, CaseIterable {
    case project = "Проект"
    case profile = "Профиль"
}

protocol ProfileViewType: AnyObject {
    func setupPages(pages: [PageType])
    func setupMenu(items: [ProfileMenuType])
    func navigation() -> UINavigationController?
    func updateUserInfo(user: UserModel)
    func setupPersonalInfo(info: [TextFieldViewModel])
    func changePage(to page: PageType)
    func showError(error: Error)
    func showSaveSuccess()
}

class ProfilePresenter {
    weak var view: ProfileViewType?
    weak var navigationDelegate: TabConfiguratorDelegate?
    
    private var userService = UserService.shared
    private var storageService = StorageService.shared
    private var user: UserModel
    private var pages: [PageType] = []
    
    init(user: UserModel) {
        self.user = user
    }
    
    func viewDidLoad() {
       determineState()
    }
    
    func viewDidAppear() {
        loadUser()
        determineState()
    }
    
    func loadUser() {
        SwiftLoader.show(animated: true)
        
        FirestoreService.shared.loadUser(userId: user.id) { [weak self] result in
            SwiftLoader.hide()
            
            switch result {
            case .success(let user):
                UserService.shared.user = user
                self?.user = user
                self?.determineState()
            case .failure(let error):
                self?.view?.showError(error: error)
            }
        }
    }
    
    func determineState() {
        reload()
    }
    
    func reload() {
        setupPages()
        setupMenu()
        setupPersonalInfo()
    }
    
    func logout() {
        AuthService.shared.logout()
    }
}

//MARK: - Setup initial state

extension ProfilePresenter {
    func setupMenu() {
        var menuItems: [ProfileMenuType] = []
        
        if user.userType == .client {
            menuItems = [.form, .agreement, .examples, .sketches, .visualizations, .project]
        } else if user.userType == .admin || user.userType == .developer {
            menuItems = [.allProjects, .users, .main, .calculator]
        } else if user.userType == .worker {
            menuItems = [.allProjects, .calculator]
        } else if user.userType == .contentManager {
            menuItems = [.allProjects, .calculator]
        }
        
        view?.setupMenu(items: menuItems)
        
        view?.updateUserInfo(user: user)
    }
    
    func setupPersonalInfo() {
        var personalInfo: [TextFieldViewModel] = []
        
        personalInfo = [
            .init(type: .name, value: user.firstName, canEdit: false),
            .init(type: .middleName, value: user.middleName ?? "", canEdit: false),
            .init(type: .lastName, value: user.lastName, canEdit: false),
            .init(type: .birthday, value: user.birthday, canEdit: false),
            .init(type: .city, value: user.city, canEdit: false),
            .init(type: .address, value: user.address ?? "", canEdit: true),
        ]
        
        view?.setupPersonalInfo(info: personalInfo)
    }
    
    func setupPages() {
        if user.userType == .base {
            pages = [.profile]
        } else {
            pages = PageType.allCases
        }
        
        view?.setupPages(pages: pages)
    }
}

//MARK: - Actions

extension ProfilePresenter {
    func pageDidChange(index: Int) {
        let page = pages[index]
        view?.changePage(to: page)
    }
}

//MARK: - Menu

extension ProfilePresenter {
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
        case .allProjects:
            showAllProjects()
        case .users:
            showUsers()
        case .main:
            showMain()
        case .calculator:
            showCalculator()
        }
    }
    
    func showTextMenu(type: ProfileMenuType) {
        guard let project = user.projects.first else { return }
        
        let view = TextMenuViewController()
        let presenter = TextMenuPresenter(type: type, project: project)
        view.presenter = presenter
        presenter.view = view
        
        self.view?.navigation()?.pushViewController(view, animated: true)
    }
    
    func showGalleryMenu(type: ProfileMenuType) {
        guard let project = user.projects.first else { return }
        
        let view = PhotoGalleryViewController()
        let presenter = PhotoGalleryPresenter(type: type, project: project)
        view.presenter = presenter
        presenter.view = view
        
        self.view?.navigation()?.pushViewController(view, animated: true)
    }
}

//MARK: - User

extension ProfilePresenter {
    func showForm() {
        guard let project = user.projects.first else { return }
        
        let view = TextMenuViewController()
        let presenter = FormPresenter(type: .form, project: project)
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
        showTextMenu(type: .sketches)
    }
    
    func showVisualizations() {
        showGalleryMenu(type: .visualizations)
    }
}

//MARK: - Admin

extension ProfilePresenter {
    func showAllProjects() {
        let view = TextMenuViewController()
        let presenter = ProjectsPresenter(user: user)
        view.presenter = presenter
        presenter.view = view
        
        self.view?.navigation()?.pushViewController(view, animated: true)
    }
    
    func showUsers() {
        let view = UsersViewController()
        let presenter = UsersPresenter()
        view.presenter = presenter
        presenter.view = view
        
        self.view?.navigation()?.pushViewController(view, animated: true)
    }
    
    func showMain() {
        let examples = DataStore.shared.examples
        let presenter = PortfolioExamplePresenter(examples: examples, type: .editing)
        let view = PortfolioExamplesViewController()
        view.presenter = presenter
        presenter.view = view
        
        self.view?.navigation()?.pushViewController(view, animated: true)
    }
    
    func showCalculator() {
        let view = CalculatorViewController()
        let presenter = CalculatorPresenter()
        view.presenter = presenter
        presenter.view = view
        
        self.view?.navigation()?.pushViewController(view, animated: true)
    }
}

extension ProfilePresenter {
    func setAvatar(image: UIImage) {
       
        guard let data = image.jpegData(compressionQuality: Constants.compressionQuality) else {
            return
        }
        
        SwiftLoader.show(animated: true)
        
        storageService.saveData(data: data, referenceType: .avatars) { [weak self] result in
            SwiftLoader.hide()
            guard let self = self else { return }
            
            switch result {
            case .success(let url):
                self.user.avatarUrl = url.absoluteString
                self.view?.updateUserInfo(user: self.user)
                self.saveUser()
            case .failure(let error):
                self.view?.showError(error: error)
            }
        }
    }
    
    func saveUser() {
        SwiftLoader.show(animated: true)

        FirestoreService.shared.save(reference: .users, data: self.user) { [weak self] result in
            SwiftLoader.hide()
            
            switch result {
            case .success():
                self?.view?.showSaveSuccess()
            case .failure(let error):
                self?.view?.showError(error: error)
            }
        }
    }
    
    func saveButtonPressed(models: [TextFieldViewModel]) {
        for model in models {
            switch model.type {
            case .address:
                self.user.address = model.value
            default:
                break
            }
        }
        saveUser()
    }
    
    func securityButtonPressed() {
        let view = SecurityViewController()
        let presenter = SecurityPresenter()
        view.presenter = presenter
        presenter.view = view
        
        self.view?.navigation()?.pushViewController(view, animated: true)
    }
}
