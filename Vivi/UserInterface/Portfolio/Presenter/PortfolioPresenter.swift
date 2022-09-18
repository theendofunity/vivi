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
    func setExamples(examples: [ProjectExample])
}

class PortfolioPresenter {
    weak var view: PortfolioViewType?
    var examples: [ProjectExample] = []
    
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
        FirestoreService.shared.load(referenceType: .examples) { [weak self] (result: Result<[ProjectExample], Error>) in
            switch result {
            case .success(let examples):
                self?.examples = examples
                self?.view?.setExamples(examples: examples)
            case .failure(let error):
                self?.view?.showError(error: error)
            }
        }
    }
    
    func openExamples() {
        let view = PortfolioExamplesViewController()
        let presenter = PortfolioExamplePresenter(examples: examples, type: .showing)
        view.presenter = presenter
        presenter.view = view
        
        self.view?.navigationController()?.pushViewController(view, animated: true)
    }
}
