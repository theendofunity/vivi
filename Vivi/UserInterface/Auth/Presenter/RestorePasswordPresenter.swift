//
//  RestorePasswordPresenter.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 14.07.2022.
//

import Foundation

protocol RestorePasswordViewType: AnyObject {
    func showError(error: Error)
    func showSuccess()
}

class RestorePasswordPresenter {
    weak var view: RestorePasswordViewType?
    
    func restoreButtonPressed(email: String) {
        let validator = EmailValidator()
        if let error = validator.validate(text: email) {
            view?.showError(error: error)
            return
        }
        
        AuthService.shared.restorePassword(email: email) { [weak self] result in
            switch result {
            case .success():
                self?.view?.showSuccess()
            case .failure(let error):
                self?.view?.showError(error: error)
            }
        }
    }
}
