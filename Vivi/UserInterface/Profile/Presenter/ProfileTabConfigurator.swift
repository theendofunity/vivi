//
//  ProfileConfigurator.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 29.05.2022.
//

import UIKit

class ProfileTabConfigurator: TabConfigurator {
    override func showContent() {
        showProfile()
    }
    
    func showProfile() {
        if navigation.viewControllers.last is ProfileViewController {
            return
        }
        
        guard let user = UserService.shared.user else { return }
        let profileViewController = ProfileViewController()
        let profilePresenter = ProfilePresenter(user: user)
        profileViewController.presenter = profilePresenter
        profilePresenter.view = profileViewController
        profilePresenter.navigationDelegate = self
        navigation.setViewControllers([profileViewController], animated: true)
    }
}

