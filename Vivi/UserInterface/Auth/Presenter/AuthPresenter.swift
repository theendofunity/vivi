//
//  AuthPresenter.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 03.05.2022.
//

import Foundation
import UIKit

protocol AuthViewType: AnyObject {
    func navigation() -> UINavigationController?
    func showError(error: Error)
    func showSuccess()
}

protocol AuthDelegate: AnyObject {
    func authSuccess()
}

class AuthPresenter {
    weak var view: AuthViewType?
    weak var delegate: AuthDelegate?
    
    func viewDidLoad() {
        
    }
    
    func registerButtonDidTouch() {
        let registrationView = RegistrationViewController()
        let registrationPresenter = RegistrationPresenter()
        registrationView.presenter = registrationPresenter
        registrationPresenter.view = registrationView
        registrationView.hidesBottomBarWhenPushed = true
        view?.navigation()?.pushViewController(registrationView, animated: true)
    }
    
    func signInButtonDidTouch(email: String, password: String) {
        signIn(email: email, password: password)
    }
    
    func signIn(email: String, password: String) {
        AuthService.shared.signIn(email: email, password: password) { result in
            switch result {
                
            case .success(let user):
                FirestoreService.shared.loadUser(userId: user.uid) { result in
                    switch result {
                    case .success(let user):
                        UserService.shared.user = user
                        print(user)
                        self.delegate?.authSuccess()
                    case .failure(let error):
                        self.view?.showError(error: error)
                    }
                }
            case .failure(let error):
                self.view?.showError(error: error)
            }
        }
    }
}
