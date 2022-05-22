//
//  FirestoreService.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 10.05.2022.
//

import Foundation
import FirebaseFirestore


class FirestoreService {
    static var shared = FirestoreService()
    private var db = Firestore.firestore()
    
    enum Reference: String {
        case users = "users"
    }
    
    private init() {}
    
    func saveUser(user: UserModel, completion: @escaping VoidCompletion) {
        guard let id = user.id else {
            completion(.failure(NSError()))
            return
        }
        let ref = db.collection(Reference.users.rawValue).document(id)
        
        ref.setData(user.representation()) { error in
            guard let error = error else {
                completion(.success(Void()))
                return
            }
            completion(.failure(error))
        }
    }
    
    func loadUser(userId: String, completion: @escaping UserModelCompletion) {
        let ref = db.collection(Reference.users.rawValue).document(userId)
        
        ref.getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let snapshot = snapshot,
            let data = snapshot.data(),
            let userModel = UserModel(document: data) else {
                return
            }
            
            completion(.success(userModel))
        }
    }
}
