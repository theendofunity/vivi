//
//  SecurityPresenter.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 15.07.2022.
//

import Foundation
import Firebase

protocol SecurityViewType: AnyObject {
    func showError(error: Error)
    func showSuccess(message: String)
}

class SecurityPresenter {
    weak var view: SecurityViewType?
    
    func changePassword(oldPassword: String, newPassword: String) {
        guard let currentUser = AuthService.shared.currentUser,
        let email = currentUser.email else { return }
        let credential = EmailAuthProvider.credential(withEmail: email, password: oldPassword)
        
        currentUser.reauthenticate(with: credential) { [weak self] result, error in
            if let error = error {
                self?.view?.showError(error: error)
                return
            } else {
                currentUser.updatePassword(to: newPassword) { error in
                    if let error = error {
                        self?.view?.showError(error: error)
                        return
                    }
                    self?.view?.showSuccess(message: "Пароль успешно изменен")
                }
            }
        }
    }
}
