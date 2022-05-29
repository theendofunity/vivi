//
//  UserModel.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 10.05.2022.
//

import Foundation

enum UserType: String {
    case user
    case admin
    case developer
}

struct UserModel: FirestoreSavable {
    var id: String?
    let firstName: String
    let lastName: String
    let middleName: String?
    let city: String
    let phone: String
    
    var project: String?
    var target: String?
    var userType: UserType = .user
    var address: String?
    
    func representation() -> [String : Any] {
        var dict: [String : Any] = [:]
        dict = [
            "id" : id ?? "",
            "firstName" : firstName,
            "lastName" : lastName,
            "middleName" : middleName ?? "",
            "phone" : phone,
            "city" : city,
            "project" : project ?? "",
            "userType" : userType.rawValue,
            "address" : address ?? ""
        ]
        
        return dict
    }
    
    init(id: String?,
         firstName: String,
         lastName: String,
         middleName: String?,
         city: String,
         phone: String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
        self.city = city
        self.middleName = middleName
    }
    
    init?(document: [String : Any]) {
        guard let id = document["id"] as? String,
        let firstName = document["firstName"] as? String,
        let lastName = document["lastName"] as? String,
        let phone = document["phone"] as? String,
        let city = document["city"] as? String,
        let project = document ["project"] as? String,
        let userType = document["userType"] as? String else { return nil }
        
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
        self.city = city
        self.project = project
        self.userType = UserType(rawValue: userType) ?? .user
        self.middleName = document["middleName"] as? String
        self.address = document["address"] as? String
    }
    
    func usernameTitle() -> String {
        return "\(firstName) \(lastName)"
    }
    
    func documentId() -> String? {
        return id
    }
}
