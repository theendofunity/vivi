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
    
    //private data
    
    var chats: [ChatModel]?
    
    private init() { }
    
    func clearPrivateData() {
        chats = nil
    }
}
