//
//  RegistrationPresenter.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 04.05.2022.
//

import Foundation

protocol RegistrationViewType: AnyObject {
    func setFields(fields: [TextFieldViewModel])
    func showError(error: Error)
    func showSuccess()
    func showAnimation()
    func hideAnimation()
}

protocol RegistrationDelegate: AnyObject {
    func registrationSuccess()
}

class RegistrationPresenter {
    weak var view: RegistrationViewType?
    weak var delegate: RegistrationDelegate?
    
    private var user: UserModel?
    
    func viewDidLoad() {
        createFields()
    }
    
    func createFields() {
        let fieldTypes: [TextFieldType] = [
            .name,
            .middleName,
            .lastName,
            .city,
            .email,
            .phone,
            .password
        ]
        let fields = fieldTypes.map {
            TextFieldViewModel(type: $0, value: "", canEdit: true)
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
        let user = UserModel(firstName: firstName,
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

        view?.showAnimation()
        AuthService.shared.registerUser(email: email, password: password) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let newUser):
                self.user?.id = newUser.uid
                self.saveUser()
            case .failure(let error):
                self.view?.hideAnimation()
                self.view?.showError(error: error)
            }
        }
    }
    
    func saveUser() {
        guard let user = user else { return }
        FirestoreService.shared.save(reference: .users, data: user) { [weak self] result in
            self?.view?.hideAnimation()
            switch result {
            case .success():
                UserService.shared.user = user
                self?.view?.showSuccess()
            case .failure(let error):
                self?.view?.showError(error: error)
            }
        }
    }
    
    func registrationSuccess() {
        delegate?.registrationSuccess()
    }
}
