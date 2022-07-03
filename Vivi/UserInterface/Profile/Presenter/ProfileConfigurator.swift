//
//  ProfileConfigurator.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 29.05.2022.
//

import UIKit

protocol ProfileNavigationDelegate: AnyObject {
    func stateChanged()
}

class ProfileConfigurator {
    var navigation: UINavigationController
    
    init(navigation: UINavigationController) {
        self.navigation = navigation
        
        determineState()
    }
    
    func determineState() {
        if AuthService.shared.isLoggedIn {
            showProfile()
        } else {
            showAuth()
        }
    }
    
    func showAuth() {
        let authPresenter = AuthPresenter()
        let authViewController = AuthViewController()
        
        authPresenter.view = authViewController
        authPresenter.delegate = self
        authViewController.presenter = authPresenter
        authViewController.navigationItem.setHidesBackButton(true, animated: false)
        navigation.setViewControllers([authViewController], animated: true)
    }
    
    func showProfile() {
        guard let user = UserService.shared.user else { return }
        let profileViewController = ProfileViewController()
        let profilePresenter = ProfilePresenter(user: user)
        profileViewController.presenter = profilePresenter
        profilePresenter.view = profileViewController
        profilePresenter.navigationDelegate = self
        navigation.setViewControllers([profileViewController], animated: true)
    }
    
    func showUserBase() {
        
    }
}

extension ProfileConfigurator: AuthDelegate {
    func authSuccess() {
        stateChanged()
    }
}

extension ProfileConfigurator: ProfileNavigationDelegate {
    func stateChanged() {
        determineState()
    }
}
