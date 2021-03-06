//
//  PortfolioPresenter.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 02.05.2022.
//

import Foundation
import UIKit

protocol PortfolioViewType: AnyObject {
    func setServices(services: [ServiceType])
    func navigationController() -> UINavigationController?
    func showError(error: Error)
    func setExamples(examples: [ExamplesViewModel])
}

class PortfolioPresenter {
    weak var view: PortfolioViewType?
        
    func viewDidLoad() {
        configureServices()
        loadExamples()
    }
    
    func configureServices() {
        view?.setServices(services: ServiceType.allCases)
    }
    
    func serviceDidSelect(service: ServiceType) {
        let serviceDetails = ServiceDetailsViewController(serviceType: service)
        view?.navigationController()?.present(serviceDetails, animated: true)
    }
    
    func loadExamples() {
        StorageService.shared.getUrls(.examples) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let urls):
                let viewModels = urls.map { ExamplesViewModel(mainImageUrl: $0) }
                self.view?.setExamples(examples: viewModels)
            case .failure(let error):
                self.view?.showError(error: error)
            }
        }
    }
}
