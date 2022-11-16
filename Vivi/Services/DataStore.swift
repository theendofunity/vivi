//
//  DataStore.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 29.08.2022.
//

import Foundation

class DataStore {
    static var shared = DataStore()
 
    //public data
    var examples: [ProjectExample] = []
    var settings: SettingsModel?
    
    //private data
    
    var chats: [ChatModel]?
    
    private init() { }
    
    func clearPrivateData() {
        chats = nil
    }
    
    func unreadChats() -> Int? {
        guard let chats else { return nil }
                
        let unreadCount = chats.filter {
            if let message = $0.lastMessage {
                return !message.isReadedByMe()
            } else {
                return false
            }
        }
        
        if unreadCount.count == 0 {
            return nil
        }
        
        return unreadCount.count
    }
}
