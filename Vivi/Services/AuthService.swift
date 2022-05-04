//
//  AuthService.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 03.05.2022.
//

import Foundation
import FirebaseAuth

typealias UserCompletion = (Result<User, Error>) -> Void

class AuthService {
    static var shared = AuthService()
    private var auth = Auth.auth()
    
    var isLogedIn: Bool {
//        auth.currentUser != nil
        false
    }
    
    private init() {}
    
    func registerUser(email: String, password: String, completion: @escaping UserCompletion) {
        auth.createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let result = result {
            completion(.success(result.user))
            }
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping UserCompletion) {
        auth.signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let result = result {
                completion(.success(result.user))
            }
        }
    }
}
