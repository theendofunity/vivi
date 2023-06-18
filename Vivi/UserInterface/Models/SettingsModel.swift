//
//  SettingsModel.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 17.11.2022.
//

import Foundation

struct SettingsModel: FirestoreSavable {
    let agreementUrl: String
    
    init?(document: [String : Any]) {
        agreementUrl = document["agreementUrl"] as? String ?? ""
    }
    
    func documentId() -> String? {
        return "main_settings"
    }
    
    func representation() -> [String : Any] {
        return [:]
    } 
}
