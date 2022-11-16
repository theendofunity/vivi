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
    
    var isLoggedIn: Bool {
        auth.currentUser != nil
    }
    
    var currentUser: User? {
        return auth.currentUser
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
    
    func logout() {
        try? auth.signOut()
        UserService.shared.user = nil
        DataStore.shared.clearPrivateData()
        
        NotificationCenter.default.post(name: .logout, object: nil)
    }
    
    func restorePassword(email: String, completion: @escaping VoidCompletion) {
        auth.sendPasswordReset(withEmail: email) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(Void()))
            }
        }
    }
    
    func deleteUser(completion: @escaping VoidCompletion) {
        guard let currentUser = currentUser else {
            return
        }
        
        currentUser.delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                FirestoreService.shared.deleteUserData(userId: currentUser.uid) { result in
                    switch result {
                    case .success():
                        completion(.success(Void()))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
    }
}
