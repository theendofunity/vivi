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
    
    func loadUser(id: String, completion: UserCompletion) {
        
    }
}
