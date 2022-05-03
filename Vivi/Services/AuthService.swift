//
//  AuthService.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 03.05.2022.
//

import Foundation

class AuthService {
    static var shared = AuthService()
    
    var isLogedIn: Bool {
        return false
    }
    
    private init() {}
}
