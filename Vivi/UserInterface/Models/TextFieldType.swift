//
//  RegistrationFieldType.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 05.05.2022.
//

import Foundation

enum TextFieldType: CaseIterable {
    case unknown
    case name
    case middleName
    case lastName
    case city
    case email
    case password
    case phone
    case title
    case address
    case type
    case square
    
    func fieldTitle() -> String {
        switch self {
        case .name:
            return "Имя"
        case .middleName:
            return "Отчество (при наличии)"
        case .lastName:
            return "Фамилия"
        case .city:
            return "Город"
        case .email:
            return "Email"
        case .password:
            return "Пароль"
        case .phone:
            return "Номер телефона"
        case .address:
            return "Адрес"
        case .title:
            return "Название"
        case .type:
            return "Тип"
        case .square:
            return "Площадь помещения"
        default:
            return ""
            
        }
    }
    
    func placeholder() -> String {
        switch self {
        case .name:
            return "Имя"
        case .middleName:
            return "Отчество (при наличии)"
        case .lastName:
            return "Фамилия"
        case .city:
            return "Город"
        case .email:
            return "Email"
        case .password:
            return "Пароль"
        case .phone:
            return "Номер телефона"
        default:
            return ""
        }
    }
}
