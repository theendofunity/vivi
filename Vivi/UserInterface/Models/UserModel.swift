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

struct UserModel {
    var id: String?
    let firstName: String
    let lastName: String
    let middleName: String?
    let city: String
    let phone: String
    
    var project: String?
    var target: String?
    var userType: UserType = .user
    
    func representation() -> [String : Any] {
        var dict: [String : Any] = [:]
        dict = [
            "id" : id,
            "firstName" : firstName,
            "lastName" : lastName,
            "middleName" : middleName ?? "",
            "phone" : phone,
            "city" : city,
            "project" : project ?? "",
            "userType" : userType.rawValue
        ]
        
        return dict
    }
}
