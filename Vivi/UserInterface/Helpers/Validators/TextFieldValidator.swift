//
//  TextFieldValidator.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 06.07.2022.
//

import UIKit

class TextFieldValidator {
    static func validate(type: TextFieldType, text: String?) -> Error? {
        guard let text = text else { return ValidationError.empty}
        
        guard let validator = validator(type: type) else { return nil }
        
        return validator.validate(text: text)
    }
    
    static func validator(type: TextFieldType) -> ValidatorType? {
        switch type {
        case .name, .lastName, .city, .address:
            return NameValidator()
        case .email:
            return EmailValidator()
        case .phone:
            return PhoneValidator()
        case .password, .oldPassword, .newPassword:
            return PasswordValidator()
        case .birthday:
            return BirthdayValidator()
        default:
            return nil
        }
    }
}

protocol ValidatorType: AnyObject {
    var type: TextFieldType { get set }
    func validate(text: String) -> Error?
    func isValid(text: String) -> Bool
}

class NameValidator: ValidatorType {
    var type: TextFieldType = .name

    func validate(text: String) -> Error? {
        if isValid(text: text) {
            return nil
        }
        return ValidationError.empty
    }
    
    func isValid(text: String) -> Bool {
        return !text.isEmpty
    }
}

class EmailValidator: ValidatorType {
    var type: TextFieldType = .email
    
    func validate(text: String) -> Error? {
        if text.isEmpty {
            return ValidationError.empty
        } else if !isValid(text: text) {
            return ValidationError.incorrectEmail
        } else {
            return nil
        }
    }
    
    func isValid(text: String) -> Bool {
        return text.isValidEmail()
    }
}

class PhoneValidator: ValidatorType {
    var type: TextFieldType = .phone
    
    func validate(text: String) -> Error? {
        if text.isEmpty {
            return ValidationError.empty
        } else if !isValid(text: text) {
            return ValidationError.incorrectPhone
        } else {
            return nil
        }
    }
    
    func isValid(text: String) -> Bool {
        return text.isValidPhone()
    }
}

class PasswordValidator: ValidatorType {
    var type: TextFieldType = .password
    
    func validate(text: String) -> Error? {
        if text.isEmpty {
            return ValidationError.empty
        } else if !isValid(text: text) {
            return ValidationError.incorrectPassword
        } else {
            return nil
        }
    }
    
    func isValid(text: String) -> Bool {
        return text.count >= 6 && text.count <= 20
    }
}

class BirthdayValidator: ValidatorType {
    var type: TextFieldType = .birthday
    
    func validate(text: String) -> Error? {
        if text.isEmpty {
            return ValidationError.empty
        } else if !isValid(text: text) {
            return ValidationError.incorrectDate
        } else {
            return nil
        }
    }
    
    func isValid(text: String) -> Bool {
        let dateformater = DateFormatter()
        dateformater.timeStyle = .none
        dateformater.dateStyle = .medium
        if let date = dateformater.date(from: text) {
            let currentDate = Date()
            var component = DateComponents()
            component.year = -18
            let targetDate = Calendar.current.date(byAdding: component, to: currentDate) ?? Date()
            return date <= targetDate
        } else {
            return false
        }
    }
    
    
}



