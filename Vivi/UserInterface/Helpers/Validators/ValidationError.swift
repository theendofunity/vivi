//
//  ValidationError.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 06.07.2022.
//

import Foundation

enum ValidationError {
    case empty
    case incorrectEmail
    case incorrectPhone
    case incorrectPassword
}

extension ValidationError: LocalizedError {
    var errorDescription: String? {
        switch self {
            
        case .empty:
            return "Заполните поле"
        case .incorrectEmail:
            return "Введите корректный email"
        case .incorrectPhone:
            return "Введите корректный номер телефона"
        case .incorrectPassword:
            return "6-20 символов, латиница"
        }
    }
}
