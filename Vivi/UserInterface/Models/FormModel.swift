//
//  FormModel.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 19.09.2022.
//

import Foundation

struct FormModel: FirestoreSavable {
    var url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    init?(document: [String : Any]) {
        guard let string = document["url"] as? String,
        let url = URL(string: string) else { return nil }
        self.url = url
    }
    
    func documentId() -> String? {
        return UUID().uuidString
    }
    
    func representation() -> [String : Any] {
        return [ "url" : url.absoluteString ]
    }
    
    
}
