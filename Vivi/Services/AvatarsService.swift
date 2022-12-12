//
//  AvatarsService.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 13.12.2022.
//

import Foundation

class AvatarsService {
    static var shared = AvatarsService()
    
    func getAvatarUrl(for chat: ChatModel, completion: @escaping OptionalUrlCompletion) {
        switch chat.type {
            
        case .project:
            loadProjectAvatar(project: chat.title, completion: completion)
        case .person:
            guard let currentUser = UserService.shared.user,
                  let otherUser = chat.users.first(where: { $0 != currentUser.id })
            else {
                return
            }
            
            loadUserAvatar(user: otherUser, completion: completion)
        }
    }
    
    private func loadProjectAvatar(project: String, completion: @escaping OptionalUrlCompletion) {
        FirestoreService.shared.load(referenceType: .projects) { (result: Result<[ProjectModel], Error>) in
            switch result {
            case .success(let projects):
                if let currentProject = projects.first(where: { $0.title == project }) {
                    completion(currentProject.avatarUrl)
                }
            case .failure(_):
                completion(nil)
            }
        }
    }
    
    private func loadUserAvatar(user: String, completion: @escaping OptionalUrlCompletion) {
        FirestoreService.shared.loadUser(userId: user) { result in
            switch result {
            case .success(let user):
                completion(user.avatarUrl)
            case .failure(_):
                completion(nil)
            }
        }
    }
}
