//
//  UserModel.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 10.05.2022.
//

import Foundation
import MessageKit

enum UserType: String, CaseIterable {
    case base
    case client
    case admin
    case developer
    case worker
}

struct UserModel: FirestoreSavable, Hashable {
    var id: String
    let firstName: String
    let lastName: String
    let middleName: String?
    let city: String
    let phone: String
    let birthday: String
    
    var projects: [String] = []
    var target: String?
    var userType: UserType = .base
    var address: String?
    
    var chats: [String] = []
    
    var avatarUrl: String?
    var avatar: UIImage?
    
    func representation() -> [String : Any] {
        var dict: [String : Any] = [:]
        dict = [
            "id" : id,
            "firstName" : firstName,
            "lastName" : lastName,
            "middleName" : middleName ?? "",
            "phone" : phone,
            "city" : city,
            "projects" : projects,
            "userType" : userType.rawValue,
            "address" : address ?? "",
            "avatarUrl" : avatarUrl ?? "",
            "chats" : chats,
            "birthday" : birthday
        ]
        
        return dict
    }
    
    init(firstName: String,
         lastName: String,
         middleName: String?,
         city: String,
         phone: String,
         birthday: String) {
        self.id = UUID().uuidString
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
        self.city = city
        self.middleName = middleName
        self.birthday = birthday
    }
    
    init?(document: [String : Any]) {
        guard let id = document["id"] as? String,
        let firstName = document["firstName"] as? String,
        let lastName = document["lastName"] as? String,
        let phone = document["phone"] as? String,
        let city = document["city"] as? String,
        let birthday = document["birthday"] as? String,
        let userType = document["userType"] as? String else { return nil }
        
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
        self.birthday = birthday
        self.city = city
        self.projects = document["projects"] as? [String] ?? []
        self.userType = UserType(rawValue: userType) ?? .base
        self.middleName = document["middleName"] as? String
        self.address = document["address"] as? String
        self.avatarUrl = document["avatarUrl"] as? String ?? nil
        self.chats = document["chats"] as? [String] ?? []
    }
    
    func usernameTitle() -> String {
        return "\(firstName) \(lastName)"
    }
    
    func documentId() -> String? {
        return id
    }
    
    static func == (lhs: UserModel, rhs: UserModel) -> Bool {
        return lhs.documentId() == rhs.documentId()
    }
}

extension UserModel: HeaderRepresentable {
    func headerTitle() -> String {
        return usernameTitle()
    }
    
    func addressTitle() -> String {
        return address ?? ""
    }
    
    func imageUrl() -> URL? {
        guard let urlString = avatarUrl else { return nil }
        return URL(string: urlString)
    }
}

extension UserModel: SenderType {
    var senderId: String {
        return id
    }
    
    var displayName: String {
        return usernameTitle()
    }
}
