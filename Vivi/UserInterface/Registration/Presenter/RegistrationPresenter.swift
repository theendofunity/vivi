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
    private var user: UserModel?
    
    func viewDidLoad() {
        createFields()
    }
    
    func createFields() {
        let fields = TextFieldType.allCases.filter {
            $0 != .unknown
        }
        view?.setFields(fields: fields)
    }
    
    func registerButtonPressed(email: String,
                               password: String,
                               firstName: String,
                               lastName: String,
                               middleName: String?,
                               phone: String,
                               city: String) {
        let user = UserModel(id: nil,
                             firstName: firstName,
                             lastName: lastName,
                             middleName: middleName,
                             city: city,
                             phone: phone)
        self.user = user
        
        if validate() {
            register(email: email, password: password)
        }
    }
    
    func validate() -> Bool {
        return true
    }
    
    func register(email: String, password: String) {
        guard let _ = user else {
            return
        }

        AuthService.shared.registerUser(email: email, password: password) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let newUser):
                self.user?.id = newUser.uid
                self.saveUser()
            case .failure(let error):
                self.view?.showError(error: error)
            }
        }
    }
    
    func saveUser() {
        guard let user = user else { return }
        FirestoreService.shared.saveUser(user: user) { result in
            switch result {
            case .success():
                self.view?.showSuccess()
            case .failure(let error):
                self.view?.showError(error: error)
            }
        }
    }
}
