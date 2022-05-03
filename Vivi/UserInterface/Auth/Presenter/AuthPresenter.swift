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
        
        view?.navigation()?.pushViewController(registrationView, animated: true)
    }
}
