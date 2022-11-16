//
//  Errors.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 10.11.2022.
//

import Foundation

enum CustomError {
    case chatAlreadyExist
    case noUser
}

extension CustomError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .chatAlreadyExist:
            return "Чат уже существует"
        case .noUser:
            return "Пользователь не найден. Попробуйте позже"
        }
    }
}
