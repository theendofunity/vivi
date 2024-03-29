//
//  ChatService.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 10.11.2022.
//

import Foundation
import Firebase

class ChatService {
    static var shared = ChatService()
    
    private init() {}
    
    //MARK: - Chats
    
    func createChat(chat: ChatModel, completion: @escaping VoidCompletion) {
        let ref = FirestoreService.shared.db.collection(FirestoreService.Reference.chats.rawValue).document(chat.id)
        
        ref.getDocument { document, error in
            if let document, document.exists {
                completion(.success(Void()))
            } else {
                ref.setData(chat.representation()) { error in
                    if let error = error {
                        completion(.failure(error))
                    }
                    chat.users.forEach {
                        self.addUserToChat(userId: $0, chatId: chat.id)
                    }
                    completion(.success(Void()))
                    
                    if let currentUser = UserService.shared.user {
                        var updatedUser = currentUser
                        updatedUser.chats.append(chat.id)
                        UserService.shared.user = updatedUser
                    }
                }
            }
        }
    }
    
    func sendMessage(chat: ChatModel, completion: @escaping VoidCompletion) {
        guard let message = chat.lastMessage else { return }
        
        let ref = FirestoreService.shared.db
            .collection(FirestoreService.Reference.chats.rawValue)
            .document(chat.id)
            .collection("messages")
            .document(message.id)
       
        ref.setData(message.representation()) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            self.updateLastMessage(chat: chat)
            
            completion(.success(Void()))
        }
    }
    
    func updateLastMessage(chat: ChatModel) {
        guard let message = chat.lastMessage else { return }
        let chatRef = FirestoreService.shared.db
            .collection(FirestoreService.Reference.chats.rawValue)
            .document(chat.id)
        chatRef.updateData(["lastMessage" : message.representation()])
    }
    
    func loadChats(completion: @escaping ChatsCompletion) {
        guard let currentUser = AuthService.shared.currentUser else { return }
        let ref = FirestoreService.shared.db.collection(FirestoreService.Reference.chats.rawValue).whereField("users", arrayContains: currentUser.uid)
        
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
    
    func addUserToChat(userId: String, chatId: String) {
        FirestoreService.shared.db.collection(FirestoreService.Reference.users.rawValue).document(userId).updateData(["chats" : FieldValue.arrayUnion([chatId])])
    }
    
    func readMessage(message: MessageModel) {
        guard let user = UserService.shared.user else { return }
        
        let ref = FirestoreService.shared.db
            .collection(FirestoreService.Reference.chats.rawValue)
            .document(message.chatID)
            .collection("messages")
            .document(message.id)
        ref.updateData(["readed" : FieldValue.arrayUnion([user.id])])
    }
    
    func startChatWithAdmin(completion: @escaping VoidCompletion) {
        guard let currentUser = UserService.shared.user else { return }
        
        FirestoreService.shared.loadUsers(type: .contentManager) { result in
            switch result {
            case .success(let user):
                let chat = ChatModel(users: [currentUser.id, user.id],
                                     userNames: [user.displayName, currentUser.displayName],
                                     title: "")
                
                self.createChat(chat: chat, completion: completion)
                                     
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

//MARK: - Observers

extension ChatService {
    func addMessagesObserver(chatId: String, completion: @escaping MessagesCompletion) -> ListenerRegistration? {
        let ref = FirestoreService.shared.db.collection(FirestoreService.Reference.chats.rawValue).document(chatId).collection("messages")
        
        let listener = ref.addSnapshotListener { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let snapshot = snapshot else { return }
            
            var messages: [MessageModel] = []
                        
            for diff in snapshot.documentChanges {
                guard let message = MessageModel(document: diff.document.data()) else { continue }
                let type = diff.type
                switch type {
                case .added:
                    messages.append(message)
                default:
                    break
                }
                
            }
            completion(.success(messages))
        }
        
        return listener
    }
    
    func addChatsObserver(completion: @escaping ChatsCompletion) -> ListenerRegistration? {
        guard let user = UserService.shared.user else { return nil }
        
        let ref = FirestoreService.shared.db
            .collection(FirestoreService.Reference.chats.rawValue)
            .whereField("users", arrayContains: user.id)
        
        let listener = ref.addSnapshotListener { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let snapshot = snapshot else { return }
            
            var chats: [ChatModel] = []
            for diff in snapshot.documentChanges {
                guard let chat = ChatModel(document: diff.document.data()) else { continue }
                let type = diff.type
                
                switch type {
                case .added, .modified:
                    chats.append(chat)
                default:
                    break
                }
            }
            completion(.success(chats))
        }
        return listener
    }
}
