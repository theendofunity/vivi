//
//  NewExamplePresenter.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 29.08.2022.
//

import Foundation
import UIKit
import SwiftLoader

protocol NewExampleViewType: AnyObject {
    func update(model: ProjectExample)
    func updateCover(image: UIImage)
    func showSuccess()
    func showError(error: Error)
}

class NewExamplePresenter {
    weak var view: NewExampleViewType?
    var example = ProjectExample()
    
    var storage = StorageService.shared
    
    func viewDidLoad() {
        setupItems()
    }
    
    func setupItems() {
        view?.update(model: example)
    }
}

extension NewExamplePresenter {
    func addImage(image: UIImage, section: NewExampleSection) {
        var item = ProjectExampleChapterItem()
        item.image = image
        
        switch section {
        case .drafts:
            example.drafts.images.insert(item, at: 0)
        case .visualisations:
            example.visualisations.images.insert(item, at: 0)
        case .result:
            example.result.images.insert(item, at: 0)
        }
        
        view?.update(model: example)
    }
    
    func addImageToCover(image: UIImage) {
        example.titleImage = image
        view?.updateCover(image: image)
    }
    
    func saveButtonPressed(title: String, description: String) {
        example.title = title
        example.description = description
        
        SwiftLoader.show(animated: true)
        
        let group = DispatchGroup()
        NewExampleSection.allCases.forEach { section in
            uploadImages(group: group, type: section)
        }
        
        group.notify(queue: .main) {
            FirestoreService.shared.save(reference: .examples, data: self.example) { result in
                SwiftLoader.hide()
                
                switch result {
                case .success():
                    self.view?.showSuccess()
                case .failure(let error):
                    self.view?.showError(error: error)
                }
            }
        }
    }
    
    private func uploadImages(group: DispatchGroup, type: NewExampleSection) {
        switch type {
        case .drafts:
            for item in example.drafts.images {
                if item.type == .empty {
                    continue
                }
                if let data = item.image?.jpegData(compressionQuality: 0.5) {
                    group.enter()
                    storage.saveData(data: data,
                                     referenceType: .examples) { result in
                        group.leave()
                        switch result {
                        case .success(let url):
                            self.example.drafts.urls.append(url.absoluteString)
                        case .failure(_):
                            break
                        }
                    }
                }
            }
        case .visualisations:
            for item in example.visualisations.images {
                if item.type == .empty {
                    continue
                }
                if let data = item.image?.jpegData(compressionQuality: 0.5) {
                    group.enter()
                    storage.saveData(data: data,
                                     referenceType: .examples) { result in
                        group.leave()
                        switch result {
                        case .success(let url):
                            self.example.visualisations.urls.append(url.absoluteString)
                        case .failure(_):
                            break
                        }
                    }
                }
            }
        case .result:
            for item in example.result.images {
                if item.type == .empty {
                    continue
                }
                if let data = item.image?.jpegData(compressionQuality: 0.5) {
                    group.enter()
                    storage.saveData(data: data,
                                     referenceType: .examples) { result in
                        group.leave()
                        switch result {
                        case .success(let url):
                            self.example.result.urls.append(url.absoluteString)
                        case .failure(_):
                            break
                        }
                    }
                }
            }
        }
    }
    
   
}
