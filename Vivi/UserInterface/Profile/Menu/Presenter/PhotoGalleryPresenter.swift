//
//  PhotoGalleryPresenter.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 23.05.2022.
//

import Foundation
import UIKit

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
    var user: UserModel
    
    var urls: [URL] = []
    
    var storageService = StorageService.shared
    
    init(type: ProfileMenuType, user: UserModel) {
        self.type = type
        self.user = user
    }
    
    func viewDidLoad() {
        view?.setupTitle(title: type.title())
        view?.setupButton(title: "Добавить", isHidden: false)
        loadData()
        
    }
    
    func viewDidAppear() {
        
    }
    
    func loadData() {
        guard let reference = referenceType() else { return }
        storageService.getUrls(reference) { result in
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
        guard let id = user.id else { return nil }
        
        switch type {
        case .examples:
            return .userExamples(id: id)
        default:
            return nil
        }
    }
    
    func uploadPhoto(url: URL) {
        guard let ref = referenceType() else { return }
        storageService.uploadFile(ref, fileUrl: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success():
                self.urls.append(url)
                self.view?.update(urls: self.urls)
            case .failure(let error):
                self.view?.showError(error: error)
            }
        }
    }
    
    func photoDidSelect(indexPath: IndexPath) {
        let view = DetailImageViewController()
        self.view?.navigation()?.present(view, animated: true, completion: {
            view.update(urls: self.urls, selectedIndex: indexPath)
        })
    }
}
