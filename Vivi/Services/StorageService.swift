//
//  StorageService.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 03.05.2022.
//

import UIKit
import FirebaseStorage


class StorageService {
    static var shared = StorageService()
    
    private let storage = Storage.storage()
    
    
    enum ReferenceType {
        case examples
        case users
        case user(id: String)
        case agreements(id: String)
        
        func path() -> String {
            switch self {
            case .examples:
                return "Main/Examples"
            case .users:
                return "Users"
            case .user(let id):
                return "Users/\(id)"
            case .agreements(let id):
                let userPath = ReferenceType.user(id: id).path()
                return "\(userPath)/Agreements"
            }
        }
    }
    
    private init() {}
    
    func getUrls(_ referenceType: ReferenceType, completion: @escaping UrlCompletion) {
        let ref = storage.reference(withPath: referenceType.path())
        
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
    
    func getFilesList(_ referenceType: ReferenceType, completion: @escaping StringsCompletion) {
        let ref = storage.reference(withPath: referenceType.path())
        ref.listAll { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
        
            let fileNames: [String] = result.items.compactMap { $0.name }
            completion(.success(fileNames))
        }
    }
    
    func uploadFile(_ referenceType: ReferenceType, fileUrl: URL, completion: @escaping VoidCompletion) {
        guard let fileName = fileUrl.pathComponents.last else { return }
        let ref = storage.reference(withPath: referenceType.path()).child(fileName)
        
        ref.putFile(from: fileUrl, metadata: nil) { metadata, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let _ = metadata else { return }
            completion(.success(Void()))
        }
    }
}
