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
    }
    
    private init() {}
    
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
    
    func updateUsersInProject(project: ProjectModel) {
        let ref = db.collection(Reference.projects.rawValue).document(project.title)
        ref.setData(["users" : project.users], merge: true)
    }
    
    //MARK: - Chats
    
    func createChat(chat: ChatModel, completion: @escaping VoidCompletion) {
        let ref = db.collection(Reference.chats.rawValue).document(chat.id)
        
        ref.setData(chat.representation()) { error in
            if let error = error {
                completion(.failure(error))
            }
            completion(.success(Void()))
        }
    }
    
    func sendMessage(chat: ChatModel, message: MessageModel, completion: @escaping VoidCompletion) {
        let ref = db.collection(Reference.chats.rawValue).document(chat.id).collection("messages")
        
        ref.addDocument(data: message.representation()) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            self.save(reference: .chats, data: chat) { result in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                completion(.success(Void()))
            }
        }
    }
    
    func loadChats(completion: @escaping ChatsCompletion) {
        guard let currentUser = AuthService.shared.currentUser else { return }
        let ref = db.collection(Reference.chats.rawValue).whereField("users", arrayContains: currentUser.uid)
        
        ref.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let snapshot = snapshot else { return }
            
            let chats: [ChatModel] = snapshot.documents.compactMap { ChatModel(document: $0.data()) }
            completion(.success(chats))
        }
    }
    
    func addMessagesObserver(chatId: String, completion: @escaping MessagesCompletion) -> ListenerRegistration? {
        let ref = db.collection(Reference.chats.rawValue).document(chatId).collection("messages")
        
        print("REF", ref.path)
        let listener = ref.addSnapshotListener { snapshot, error in
            print("addSnapshotListener")
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let snapshot = snapshot else { return }
            
            var messages: [MessageModel] = []
            
            print(snapshot.documentChanges.count)
            
            for diff in snapshot.documentChanges {
                print("MESSAGE", diff.document.data())
                guard let message = MessageModel(document: diff.document.data()) else { continue }
                print("PARSING OK")
                let type = diff.type
                print("type", type.rawValue)
                switch type {
                case .added:
                    print("added")
                    messages.append(message)
                case .modified:
                    print("modified")
                case .removed:
                    print("removed")
                }
                
            }
            completion(.success(messages))
        }
        
        return listener
    }
}
