//
//  TextMenuPresenter.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 22.05.2022.
//

import Foundation
import UIKit
import SwiftLoader

protocol TextMenuViewType: AnyObject {
    func setupTitle(_ title: String)
    func setupButton(title: String, isHidden: Bool)
    func setupFiles(files: [String])
    func showError(error: Error)
    func selectFile()
    func selectLink()
    
    func selectCell(indexPath: IndexPath)
    
    func navigation() -> UINavigationController?
}

protocol TextMenuPresenterProtocol: AnyObject {
    func viewDidLoad()
    func viewDidAppear()
    
    func buttonPressed()
    func fileDidSelect(filename: String)
    func loadData()
    func add(file: Any)
    func isCellSelected(indexPath: IndexPath) -> Bool
}

class TextMenuPresenter: TextMenuPresenterProtocol {
    weak var view: TextMenuViewType?
    var type: ProfileMenuType
    var project: String
    var files: [String] = []
    
    private var storageService = StorageService.shared
    
    init(type: ProfileMenuType, project: String) {
        self.type = type
        self.project = project
    }
    
    func viewDidLoad() {
        view?.setupTitle(type.title())
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
            isHidden = type != .form
        case .admin, .worker, .developer:
            isHidden = false
        }
        
        view?.setupButton(title: "Добавить", isHidden: isHidden)
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
        let id = project
        
        switch type {
        case .agreement:
            return .agreements(id: id)
        case .project:
            return .projectDoc(id: id)
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
        SwiftLoader.show(animated: true)
        storageService.getFilesList(type) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let files):
                self.files = files
                self.view?.setupFiles(files: files)
            case .failure(let error):
                self.view?.showError(error: error)
            }
            
            SwiftLoader.hide()
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
    
    func add(file: Any) {
        guard let url = file as? URL else { return }
        uploadFile(with: url)
    }
    
    func isCellSelected(indexPath: IndexPath) -> Bool {
        return false
    }
}
