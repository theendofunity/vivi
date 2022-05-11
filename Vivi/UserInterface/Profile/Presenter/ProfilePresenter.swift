//
//  ProfilePresenter.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 02.05.2022.
//

import Foundation
import UIKit

protocol ProfileViewType: AnyObject {
    func navigation() -> UINavigationController?
    
    func updateMenu(menuItems: [ProfileMenuType])
    func updateUserInfo(userName: String, address: String, avatar: URL?)
}

class ProfilePresenter {
    weak var view: ProfileViewType?
    
    var userService = UserService.shared
    
    func viewDidLoad() {
        if AuthService.shared.isLoggedIn {
            guard let _ = UserService.shared.user else {
                return
            }
            loadMenu()
        } else {
            showAuth()
        }
    }
    
    func viewDidAppear() {
        
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
    
    func logout() {
        AuthService.shared.logout()
        viewDidLoad()
    }
    
    func loadMenu() {
        guard let user = userService.user else { return }
        
        var menuItems: [ProfileMenuType]
        
        if user.userType == .user {
            menuItems = [.form, .agreement, .examples, .sketches, .visualizations, .project]
        } else {
            menuItems = [.allProjects, .users, .main]
        }
        
        view?.updateMenu(menuItems: menuItems)
        view?.updateUserInfo(userName: user.usernameTitle(), address: user.address ?? "" , avatar: nil)
    }
    
    func itemDidSelect(item: ProfileMenuType) {
        
    }
}

extension ProfilePresenter: AuthDelegate {
    func authSuccess() {
        view?.navigation()?.popViewController(animated: true)
        viewDidLoad()
    }
}
