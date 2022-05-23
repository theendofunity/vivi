//
//  TextMenuPresenter.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 22.05.2022.
//

import Foundation
import UIKit

protocol TextMenuViewType: AnyObject {
    func setupTitle(_ title: String)
    func setupButton(title: String, isHidden: Bool)
    func setupFiles(files: [String])
    func showError(error: Error)
    func selectFile()
    
    func navigation() -> UINavigationController?
}

class TextMenuPresenter {
    weak var view: TextMenuViewType?
    var type: ProfileMenuType
    var user: UserModel
    var files: [String] = []
    
    private var storageService = StorageService.shared
    
    init(type: ProfileMenuType, user: UserModel) {
        self.type = type
        self.user = user
    }
    
    func viewDidLoad() {
        view?.setupTitle(type.title())
        setupButton()
        
        loadData()
    }
    
    func viewDidAppear() {
        
    }
    
    func setupButton() {
        view?.setupButton(title: "Добавить", isHidden: false)
    }
    
    func buttonPressed() {
        view?.selectFile()
    }
    
    func fileDidSelect(filename: String) {
        guard let reference = referenceType() else { return }
        storageService.getDownloadUrl(reference, fileName: filename) { [weak self] result in
            switch result {
            case .success(let url):
                self?.showFile(url: url)
            case .failure(let error):
                self?.view?.showError(error: error)
            }
        }
    }
    
    func showFile(url: URL) {
        let view = DocumentsDetailViewController(url: url)
        self.view?.navigation()?.present(view, animated: true)
    }
}

extension TextMenuPresenter {
    func referenceType() -> StorageService.ReferenceType? {
        guard let id = user.id else { return nil }
        
        switch type {
        case .agreement:
            return .agreements(id: id)
        case .project:
            return .project(id: id)
        case .form:
            return .forms(id: id)
        default:
            return nil
        }
    }
    
    func loadData() {
        guard let reference = referenceType() else { return }
        loadFilesList(type: reference)
    }
    
    func loadFilesList(type: StorageService.ReferenceType) {
        storageService.getFilesList(type) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let files):
                self.files = files
                self.view?.setupFiles(files: files)
            case .failure(let error):
                self.view?.showError(error: error)
            }
        }
    }
    
    func uploadFile(with url: URL) {
        guard let reference = referenceType() else { return }
        
        storageService.uploadFile(reference, fileUrl: url) { [weak self] result in
            switch result {
            case .success():
                self?.loadData()
            case .failure(let error):
                self?.view?.showError(error: error)
            }
        }
    }
}
