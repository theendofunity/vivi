//
//  FirestoreSavable.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 30.05.2022.
//

import Foundation

protocol FirestoreSavable {
    init?(document: [String : Any])
    
    func documentId() -> String?
    func representation() -> [String : Any]
}
