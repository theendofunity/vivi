//
//  FirestoreService.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 10.05.2022.
//

import Foundation
import FirebaseFirestore

typealias VoidCompletion = (Result<Void, Error>) -> Void

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
}
