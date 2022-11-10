//
//  TabConfigurator.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 03.11.2022.
//

import UIKit

protocol TabConfiguratorProtocol: AnyObject {
    var navigation: UINavigationController { get set }
    
    init(navigation: UINavigationController)
    
    func determineState()
    func showAuth()
    func showContent()
}

protocol TabConfiguratorDelegate: AnyObject {
    func stateChanged()
}

class TabConfigurator: TabConfiguratorProtocol {
    var navigation: UINavigationController
    
    required init(navigation: UINavigationController) {
        self.navigation = navigation
        
        determineState()
        
        NotificationCenter.default.addObserver(self, selector: #selector(loginChanged), name: .logout, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loginChanged), name: .login, object: nil)
    }
    
    func determineState() {
        if AuthService.shared.isLoggedIn {
            showContent()
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
    
    func showContent() {
        
    }

    @objc func loginChanged() {
        determineState()
    }
}

extension TabConfigurator: TabConfiguratorDelegate, AuthDelegate {
    func stateChanged() {
        determineState()
    }
    
    func authSuccess() {
        determineState()
    }
}
