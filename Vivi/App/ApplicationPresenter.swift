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
        NotificationCenter.default.addObserver(self, selector: #selector(logout), name: .logout, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .logout, object: nil)
    }
    
    func start() {
//        authService.logout()
        loadData()
    }
    
    func loadData() {
        let group = DispatchGroup()
        if authService.isLoggedIn {
            loadUser(group: group)
            loadChats(group: group)
        }
        loadSettings(group: group)
        
        group.notify(queue: .main) {
            self.delegate?.dataLoaded()
        }
    }
    
    func loadUser(group: DispatchGroup) {
        guard let user = authService.currentUser else {
            self.authService.logout()
            return
        }
        
        group.enter()
        
        firestoreService.loadUser(userId: user.uid) { result in
            group.leave()
            switch result {
            case .success(let user):
                UserService.shared.user = user
            case .failure(_):
                self.authService.logout()
            }
        }
    }
    
    func loadChats(group: DispatchGroup) {
        group.enter()
        
        ChatService.shared.loadChats { result in
            group.leave()
            
            switch result {
            case .success(let chats):
                DataStore.shared.chats = chats
            case .failure(_):
                self.authService.logout()
            }
        }
    }
    
    func loadSettings(group: DispatchGroup) {
        group.enter()
        print(#function)

        firestoreService.load(referenceType: .settings) { (result: Result<[SettingsModel], Error>) in
            group.leave()
            switch result {
            case .success(let settings):
                DataStore.shared.settings = settings.first

            case .failure(_):
                break
            }
        }
    }
                             
    
    @objc func logout() {
        AuthService.shared.logout()
        self.delegate?.dataLoaded()
    }
}
