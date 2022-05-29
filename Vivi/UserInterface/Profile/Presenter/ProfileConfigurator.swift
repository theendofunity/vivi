//
//  ProfileConfigurator.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 29.05.2022.
//

import UIKit

class ProfileConfigurator {
    var navigation: UINavigationController
    
    init(navigation: UINavigationController) {
        self.navigation = navigation
        
        determineState()
    }
    
    func determineState() {
        if AuthService.shared.isLoggedIn {
            showProfile()
        }
    }
    
    func showAuth() {
        let authPresenter = AuthPresenter()
        let authViewController = AuthViewController()
        
        authPresenter.view = authViewController
        authPresenter.delegate = self
        authViewController.presenter = authPresenter
        authViewController.navigationItem.setHidesBackButton(true, animated: false)
        navigation.pushViewController(authViewController, animated: false)
    }
    
    func showProfile() {
        let profileViewController = ProfileViewController()
        let profilePresenter = ProfilePresenter()
        profileViewController.presenter = profilePresenter
        profilePresenter.view = profileViewController
    }
    
    func showUserBase() {
        
    }
    
    func logout() {
        AuthService.shared.logout()
        showAuth()
    }
}

extension ProfileConfigurator: AuthDelegate {
    func authSuccess() {
        determineState()
    }
}
