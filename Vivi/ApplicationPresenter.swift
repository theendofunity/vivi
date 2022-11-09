//
//  ApplicationPresenter.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 11.05.2022.
//

import Foundation

protocol ApplicationPresenterDelegate: AnyObject {
    func dataLoaded()
}

class ApplicationPresenter {
    weak var delegate: ApplicationPresenterDelegate?
    var firestoreService = FirestoreService.shared
    var authService = AuthService.shared
    
    init() {
        
    }
    
    func start() {
//        authService.logout()
        if authService.isLoggedIn {
            loadData()
        } else {
            delegate?.dataLoaded()
        }
    }
    
    func loadData() {
        loadUser()
    }
    
    func loadUser() {
        guard let user = authService.currentUser else {
            self.logout()
            return
        }
        firestoreService.loadUser(userId: user.uid) { result in
            switch result {
            case .success(let user):
                UserService.shared.user = user
                self.delegate?.dataLoaded()
            case .failure(_):
                self.logout()
            }
        }
    }
    
    func logout() {
        AuthService.shared.logout()
        DataStore.shared.clearPrivateData()
        self.delegate?.dataLoaded()
    }
}
