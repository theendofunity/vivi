//
//  TextMenuPresenter.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 22.05.2022.
//

import Foundation

protocol TextMenuViewType: AnyObject {
    func setupTitle(_ title: String)
    func setupButton(title: String, isHidden: Bool)
    func setupFiles(files: [String])
    func showError(error: Error)
    func selectFile()
}

class TextMenuPresenter {
    weak var view: TextMenuViewType?
    var type: ProfileMenuType
    var files: [String] = []
    
    private var storageService = StorageService.shared
    
    init(type: ProfileMenuType) {
        self.type = type
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
}

extension TextMenuPresenter {
    func loadData() {
        guard let user = UserService.shared.user,
              let id = user.id else {
            return
        }
        
        switch type {
        case .agreement:
            loadFilesList(type: .agreements(id: id))
        default:
            break
        }
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
        guard let user = UserService.shared.user,
              let id = user.id else {
            return
        }
        
        storageService.uploadFile(.agreements(id: id), fileUrl: url) { [weak self] result in
            switch result {
            case .success():
                self?.loadData()
            case .failure(let error):
                self?.view?.showError(error: error)
            }
        }
    }
}
