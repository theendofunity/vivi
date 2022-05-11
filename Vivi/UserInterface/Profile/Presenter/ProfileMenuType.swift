//
//  ProfileMenuType.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 11.05.2022.
//

import Foundation
import UIKit

enum ProfileMenuType {
    case form
    case agreement
    case examples
    case sketches
    case visualizations
    case project
    
    case users
    case main
    case allProjects
    
    func title() -> String {
        switch self {
        case .form:
            return "Анкета"
        case .agreement:
            return "Договор и счета"
        case .examples:
            return "Примеры"
        case .sketches:
            return "Чертежи"
        case .visualizations:
            return "Визуализации"
        case .project:
            return "Проект"
        case .users:
            return "Пользователи"
        case .main:
            return "Главная"
        case .allProjects:
            return "Проекты"
        }
    }
    
    func icon() -> UIImage? {
        return UIImage(systemName: "newspaper")
    }
}
