//
//  ProfilePagerPresenter.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 16.05.2022.
//

import Foundation
import UIKit

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
}

class ProfilePresenter {
    weak var view: ProfileViewType?
    private var userService = UserService.shared
    
    private var pages: [PageType] = []
    
    func viewDidLoad() {
        if AuthService.shared.isLoggedIn {
            guard let _ = UserService.shared.user else { return }
            
            reload()
        } else {
            showAuth()
        }
    }
    
    func viewDidAppear() {
        
    }
    
    func reload() {
        setupPages()
        setupMenu()
        setupPersonalInfo()
    }
    
    func logout() {
        AuthService.shared.logout()
        viewDidLoad()
    }
    
    func showAuth() {
        let authPresenter = AuthPresenter()
        let authViewController = AuthViewController()
        
        authPresenter.view = authViewController
        authPresenter.delegate = self
        authViewController.presenter = authPresenter
        authViewController.navigationItem.setHidesBackButton(true, animated: false)
        view?.navigation()?.pushViewController(authViewController, animated: false)
    }
}

//MARK: - Setup initial state

extension ProfilePresenter {
    func setupMenu() {
        guard let user = userService.user else { return }
        
        var menuItems: [ProfileMenuType]
        
        if user.userType == .user {
            menuItems = [.form, .agreement, .examples, .sketches, .visualizations, .project]
        } else {
            menuItems = [.allProjects, .users, .main]
        }
        
        view?.setupMenu(items: menuItems)
        
        view?.updateUserInfo(user: user)
    }
    
    func setupPersonalInfo() {
        guard let user = userService.user else { return }
        
        var personalInfo: [TextFieldViewModel] = []
        
        personalInfo = [
            .init(type: .name, value: user.firstName, canEdit: false),
            .init(type: .middleName, value: user.middleName ?? "", canEdit: false),
            .init(type: .lastName, value: user.lastName, canEdit: false),
            .init(type: .city, value: user.city, canEdit: true)
        ]
        
        view?.setupPersonalInfo(info: personalInfo)
    }
    
    func setupPages() {
        pages = PageType.allCases
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

extension ProfilePresenter: AuthDelegate {
    func authSuccess() {
        view?.navigation()?.popViewController(animated: true)
        viewDidLoad()
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
        default:
            break
        }
    }
    
    func showTextMenu(type: ProfileMenuType) {
        guard let user = userService.user else { return }
        let view = TextMenuViewController()
        let presenter = TextMenuPresenter(type: type, user: user)
        view.presenter = presenter
        presenter.view = view
        
        self.view?.navigation()?.pushViewController(view, animated: true)
    }
    
    func showGalleryMenu(type: ProfileMenuType) {
        guard let user = userService.user else { return }
        let view = PhotoGalleryViewController()
        let presenter = PhotoGalleryPresenter(type: type, user: user)
        view.presenter = presenter
        presenter.view = view
        
        self.view?.navigation()?.pushViewController(view, animated: true)
    }
    
    func showForm() {
        showTextMenu(type: .form)
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
}
