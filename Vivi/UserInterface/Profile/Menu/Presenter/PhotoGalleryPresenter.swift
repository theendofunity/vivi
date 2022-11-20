//
//  PhotoGalleryPresenter.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 23.05.2022.
//

import Foundation
import UIKit
import SwiftLoader

protocol PhotoGalleryViewType: AnyObject {
    func setupTitle(title: String)
    func setupButton(title: String, isHidden: Bool)
    func selectPhoto()
    func update(urls: [URL])
    func showError(error: Error)
    func navigation() -> UINavigationController?
}

class PhotoGalleryPresenter {
    weak var view: PhotoGalleryViewType?
    var type: ProfileMenuType
    var project: String
    
    var urls: [URL] = []
    
    var storageService = StorageService.shared
    
    init(type: ProfileMenuType, project: String) {
        self.type = type
        self.project = project
    }
    
    func viewDidLoad() {
        view?.setupTitle(title: type.title())
        setupButton()
        
        loadData()
    }
    
    func viewDidAppear() {
        
    }
    
    func setupButton() {
        guard let user = UserService.shared.user else { return }
        
        var isHidden = true
        
        switch user.userType {
        case .base:
            isHidden = true
        case .client:
            isHidden = type != .examples
        case .admin, .developer, .worker:
            isHidden = false
        }
        
        view?.setupButton(title: "Добавить", isHidden: isHidden)
    }
    
    func loadData() {
        guard let reference = referenceType() else { return }
        
        SwiftLoader.show(animated: true)

        storageService.getUrls(reference) { result in
            SwiftLoader.hide()
            switch result {
                
            case .success(let urls):
                self.urls.append(contentsOf: urls)
                self.view?.update(urls: self.urls)
            case .failure(let error):
                self.view?.showError(error: error)
            }
        }
    }
    
    func mainButtonPressed() {
        view?.selectPhoto()
    }
    
    func referenceType() -> StorageService.ReferenceType? {
        let id = project
        
        switch type {
        case .examples:
            return .userExamples(id: id)
        case .sketches:
            return .sketches(id: id)
        case .visualizations:
            return .visualizations(id: id)
        default:
            return nil
        }
    }
    
    func uploadPhoto(image: UIImage) {
        guard let ref = referenceType(),
        let data = image.jpegData(compressionQuality: 0.5) else { return }
        
        SwiftLoader.show(animated: true)

        storageService.saveData(data: data, referenceType: ref) { [weak self] result in
            SwiftLoader.hide()
            guard let self = self else { return }
            switch result {
            case .success(let url):
                self.urls.append(url)
                self.view?.update(urls: self.urls)
            case .failure(let error):
                self.view?.showError(error: error)
            }
        }
    }
    
    func photoDidSelect(indexPath: IndexPath) {
        let view = DetailImageViewController()
        view.modalPresentationStyle = .fullScreen
        self.view?.navigation()?.present(view, animated: true, completion: {
            view.update(urls: self.urls, selectedIndex: indexPath)
        })
    }
}
