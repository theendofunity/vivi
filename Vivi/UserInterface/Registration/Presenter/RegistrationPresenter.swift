//
//  RegistrationPresenter.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 04.05.2022.
//

import Foundation

protocol RegistrationViewType: AnyObject {
    func setFields(fields: [TextFieldType])
    func showError(error: Error)
    func showSuccess()
}

class RegistrationPresenter {
    weak var view: RegistrationViewType?
    
    func viewDidLoad() {
        createFields()
    }
    
    func createFields() {
        let fields = TextFieldType.allCases.filter {
            $0 != .unknown
        }
        view?.setFields(fields: fields)
    }
    
    func registerButtonPressed(email: String, password: String) {
        register(email: email, password: password)
    }
    
    func register(email: String, password: String) {
        AuthService.shared.registerUser(email: email, password: password) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.view?.showSuccess()
            case .failure(let error):
                self.view?.showError(error: error)
            }
        }
    }
}
