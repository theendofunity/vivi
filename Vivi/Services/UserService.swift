//
//  UserService.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 10.05.2022.
//

import Foundation

class UserService {
    static var shared = UserService()
    var user: UserModel?
    var authService = AuthService.shared
    private init() {
    }
    
    deinit {
        user = nil
    }
    
//    func loadUser() {
//        guard let userId = AuthService.shared.currentUser?.uid else { return }
//        FirestoreService.shared.loadUser(userId: userId) { result in
//            <#code#>
//        }
//    }
}
