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
}

class ProfilePresenter {
    weak var view: ProfileViewType?
    
    func viewDidLoad() {
        if AuthService.shared.isLogedIn {
            
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
}

extension ProfilePresenter: AuthDelegate {
    func authSuccess() {
        view?.navigation()?.popViewController(animated: true)
        viewDidLoad()
    }
}
