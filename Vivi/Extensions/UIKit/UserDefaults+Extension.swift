//
//  UserDefaults+Extension.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 18.06.2023.
//

import Foundation

extension UserDefaults {
    private enum Keys: String {
        case fcmToken
    }
    
    var fcmToken: String? {
        get {
            string(forKey: Keys.fcmToken.rawValue)
        }
        set {
            setValue(newValue, forKey: Keys.fcmToken.rawValue)
        }
    }
}
