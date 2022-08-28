//
//  DataStore.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 29.08.2022.
//

import Foundation

class DataStore {
    static var shared = DataStore()
 
    var examples: [ProjectExample] = []
    
    private init() { }
}
