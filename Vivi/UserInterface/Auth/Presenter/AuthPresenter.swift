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

class AuthPresenter {
    weak var view: AuthViewType?
    
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
                
            case .success(_):
                self.view?.showSuccess()
            case .failure(let error):
                self.view?.showError(error: error)
            }
        }
    }
}
