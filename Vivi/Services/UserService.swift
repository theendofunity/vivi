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
    
    private init() {
        loadUser()
    }
    
    deinit {
        user = nil
    }
    
    func loadUser() {
        
    }
}
