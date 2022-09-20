//
//  FormPresenter.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 19.09.2022.
//

import Foundation
import SwiftLoader

class FormPresenter: TextMenuPresenterProtocol {
    weak var view: TextMenuViewType?
    var type: ProfileMenuType
    var project: String
    
    private var storageService = StorageService.shared
    
    init(type: ProfileMenuType, project: String) {
        self.type = type
        self.project = project
    }
    
    func viewDidLoad() {
        view?.setupTitle("Анкеты")
        let isButtonHidden = UserService.shared.user?.userType == .client
        view?.setupButton(title: "Добавить", isHidden: isButtonHidden)
        loadData()

    }
    
    func viewDidAppear() {
    }
    
    func buttonPressed() {
        view?.selectLink()
    }
    
    func fileDidSelect(filename: String) {
        guard let url = URL(string: filename) else { return }
        
        let webView = WebViewController()
        webView.load(url: url)
        webView.modalPresentationStyle = .fullScreen
        view?.navigation()?.present(webView, animated: true)
    }
    
    func loadData() {
        SwiftLoader.show(animated: true)
        
        FirestoreService.shared.load(referenceType: .forms) { [weak self] (result: Result<[FormModel], Error>) in
            SwiftLoader.hide()
            
            switch result {
            case .success(let forms):
                self?.view?.setupFiles(files: forms.map({ item in
                    item.url.absoluteString
                }))
            case .failure(let error):
                self?.view?.showError(error: error)
            }
        }
    }
    
    func add(file: Any) {
        guard let url = file as? URL else { return }
        let form = FormModel(url: url)
        FirestoreService.shared.save(reference: .forms, data: form) { [weak self] result in
            switch result {
            case .success():
                self?.loadData()
            case .failure(let error):
                self?.view?.showError(error: error)
            }
        }
    }
}
