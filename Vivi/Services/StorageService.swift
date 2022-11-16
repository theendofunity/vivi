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
        case projects
        case project(id: String)
        case user(id: String)
        case agreements(id: String)
        case forms(id: String)
        case projectDoc(id: String)
        case userExamples(id: String)
        case sketches(id: String)
        case visualizations(id: String)
        case avatars
        case chatMedia
        
        func path() -> String {
            switch self {
            case .examples:
                return "Main/Examples"
            case .users:
                return "Users"
            case .user(let id):
                return "Users/\(id)"
            case .agreements(let id):
                let userPath = ReferenceType.project(id: id).path()
                return "\(userPath)/Agreements"
            case .forms(id: let id):
                let userPath = ReferenceType.project(id: id).path()
                return "\(userPath)/Forms"
            case .projectDoc(id: let id):
                let userPath = ReferenceType.project(id: id).path()
                return "\(userPath)/Project"
            case .userExamples(id: let id):
                let userPath = ReferenceType.project(id: id).path()
                return "\(userPath)/Examples"
            case .sketches(id: let id):
                let userPath = ReferenceType.project(id: id).path()
                return "\(userPath)/Sketches"
            case .visualizations(id: let id):
                let userPath = ReferenceType.project(id: id).path()
                return "\(userPath)/Visualizetions"
            case .projects:
                return "Projects"
            case .project(id: let id):
                return "\(ReferenceType.projects.path())/\(id)"
            case .avatars:
                return "Avatars"
            case .chatMedia:
                return "ChatMedia"
            }
        }
    }
    
    private init() {}
    
    func getUrls(_ referenceType: ReferenceType, completion: @escaping UrlsCompletion) {
        let ref = storage.reference(withPath: referenceType.path())
        
        ref.listAll { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            let group = DispatchGroup()
            var urls: [URL] = []
            
            for item in result.items {
                group.enter()
                item.downloadURL { url, error in
                    if let error = error {
                        completion(.failure(error))
                        group.leave()
                        return
                    }
                    if let url = url {
                        urls.append(url)
                        group.leave()
                    }
                }
            }
            
            group.notify(queue: .main) {
                completion(.success(urls))
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
    
    func uploadData(_ referenceType: ReferenceType, fileUrl: URL, completion: @escaping VoidCompletion) {
        guard let fileName = fileUrl.pathComponents.last else { return }
        let ref = storage.reference(withPath: referenceType.path()).child(fileName)
        guard let data = try? Data(contentsOf: fileUrl) else {
            completion(.failure(NSError()))
            return
        }
        ref.putData(data, metadata: nil, completion: { metadata, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let _ = metadata else { return }
            completion(.success(Void()))
        })
    }
    
    func uploadData(_ referenceType: ReferenceType, data: Data, filename: String, completion: @escaping VoidCompletion) {
       
        let ref = storage.reference(withPath: referenceType.path()).child(filename)
      
        ref.putData(data, metadata: nil, completion: { metadata, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let _ = metadata else { return }
            completion(.success(Void()))
        })
    }
    
    
    func getDownloadUrl(_ referenceType: ReferenceType, fileName: String, completion: @escaping UrlCompletion) {
        let ref = storage.reference(withPath: referenceType.path()).child(fileName)
        
        ref.downloadURL { url, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let url = url else {
                return
            }
            completion(.success(url))
        }
    }
    
    func saveImage(imageUrl: URL, referenceType: ReferenceType, completion: @escaping UrlCompletion) {
        uploadFile(referenceType, fileUrl: imageUrl) { result in
            print(result)
            switch result {
            case .success():
                guard let fileName = imageUrl.pathComponents.last else { return }
                self.getDownloadUrl(referenceType, fileName: fileName) { result in
                    switch result {
                    case .success(let url):
                        completion(.success(url))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func saveData(imageUrl: URL, referenceType: ReferenceType, completion: @escaping UrlCompletion) {
        uploadData(referenceType, fileUrl: imageUrl) { result in
            print(result)
            switch result {
            case .success():
                guard let fileName = imageUrl.pathComponents.last else { return }
                self.getDownloadUrl(referenceType, fileName: fileName) { result in
                    switch result {
                    case .success(let url):
                        completion(.success(url))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func saveData(data: Data, referenceType: ReferenceType, completion: @escaping UrlCompletion) {
        let fileName = UUID().uuidString
        uploadData(referenceType, data: data, filename: fileName) { result in
            print(result)
            switch result {
            case .success():
                self.getDownloadUrl(referenceType, fileName: fileName) { result in
                    switch result {
                    case .success(let url):
                        completion(.success(url))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
