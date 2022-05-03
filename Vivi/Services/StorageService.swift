//
//  StorageService.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 03.05.2022.
//

import UIKit
import FirebaseStorage

typealias UrlCompletion = (Result<[URL], Error>) -> Void

class StorageService {
    static var shared = StorageService()
    
    private let storage = Storage.storage()
    
    
    enum ReferenceType: String {
        case examples = "Main/Examples"
    }
    
    private init() {}
    
    func getUrls(_ referenceType: ReferenceType, completion: @escaping UrlCompletion) {
        let ref = storage.reference(withPath: referenceType.rawValue)
        
        ref.listAll { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            for item in result.items {
                var urls: [URL] = []
                item.downloadURL { url, error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    if let url = url {
                        urls.append(url)
                        completion(.success([url]))

                    }
                }
            }
        }
    }
}
