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
    var db = Firestore.firestore()
    
    enum Reference: String {
        case users = "users"
        case projects = "projects"
        case chats = "chats"
        case examples = "examples"
        case forms = "forms"
        case settings = "settings"
    }
    
    private init() {}
    
//MARK: - Base
    func save(reference: Reference, data: FirestoreSavable, completion: @escaping VoidCompletion) {
        guard let id = data.documentId() else {
            completion(.failure(NSError()))
            return
        }
        
        let ref = db.collection(reference.rawValue).document(id)
        
        ref.setData(data.representation()) { error in
            guard let error = error else {
                completion(.success(Void()))
                return
            }
            completion(.failure(error))
        }
    }
    
    func load<T: FirestoreSavable>(referenceType: Reference, completion: @escaping (Result<[T], Error>) -> Void) {
        let ref = db.collection(referenceType.rawValue)
        
        ref.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let snapshot = snapshot else { return }
            var data: [T] = []
            
            for document in snapshot.documents {
                if let model = T(document: document.data()) {
                    data.append(model)
                }
            }
            completion(.success(data))
        }
    }
    
    //MARK: - Users
    
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
    
    func loadUsers(type: UserType, completion: @escaping UserModelCompletion) {
        let ref = db.collection(Reference.users.rawValue).whereField("userType", isEqualTo: type.rawValue)
        
        ref.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let snapshot = snapshot else { return }
            
            let users: [UserModel] = snapshot.documents.compactMap { UserModel(document: $0.data()) }
            
            if let user = users.first {
                completion(.success(user))
            } else {
                completion(.failure(CustomError.noUser))
            }
        }
    }
    
    func updateUsersInProject(project: ProjectModel) {
        let ref = db.collection(Reference.projects.rawValue).document(project.title)
        ref.updateData(["users" : FieldValue.arrayUnion(project.users)])
        
        guard let id = project.documentId() else { return }
        let chatRef = db.collection(Reference.chats.rawValue).document(id)
        chatRef.updateData(["users" : FieldValue.arrayUnion(project.users)])
    }
    
    func removeUsersFromProject(project: ProjectModel, users: [String]) {
        let ref = db.collection(Reference.projects.rawValue).document(project.title)
        ref.updateData(["users" : FieldValue.arrayRemove(users)])
        
        guard let id = project.documentId() else { return }
        let chatRef = db.collection(Reference.chats.rawValue).document(id)
        chatRef.updateData(["users" : FieldValue.arrayRemove(users)])
    }
    
    func deleteUserData(userId: String, completion: @escaping VoidCompletion) {
        let ref = db.collection(Reference.users.rawValue).document(userId)
        ref.delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(Void()))
            }
        }
    }
}
