//
//  ProfilePagerPresenter.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 16.05.2022.
//

import Foundation
import UIKit

protocol ProfileViewType: AnyObject {
    func setupMenu(items: [ProfileMenuType])
    func navigation() -> UINavigationController?
    func updateUserInfo(user: UserModel)
}

class ProfilePresenter {
    weak var view: ProfileViewType?
    private var userService = UserService.shared
    
    func viewDidLoad() {
        if AuthService.shared.isLoggedIn {
            guard let _ = UserService.shared.user else {
                return
            }
            setupMenu()
        } else {
            showAuth()
        }
    }
    
    func viewDidAppear() {
        
    }
    
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
    
    func logout() {
        AuthService.shared.logout()
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

extension ProfilePresenter: AuthDelegate {
    func authSuccess() {
        view?.navigation()?.popViewController(animated: true)
        viewDidLoad()
    }
}
