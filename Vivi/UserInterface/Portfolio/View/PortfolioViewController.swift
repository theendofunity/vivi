//
//  PortfolioViewController.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 02.05.2022.
//

import UIKit
import EasyPeasy

class PortfolioViewController: UIViewController {
    weak var presenter: PortfolioPresenter!
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private lazy var exampleView: PortfolioExampleView = {
        let view = PortfolioExampleView()
        return view
    }()
    
    private lazy var serviceView: ServicesView = {
        let view = ServicesView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBarWithLogo()
        setupView()
        setupConstraints()
    }
    
    func setupView() {
        view.addSubview(scrollView)
        scrollView.addSubview(exampleView)
        scrollView.addSubview(serviceView)
    }
    
    func setupConstraints() {
        scrollView.easy.layout(
            Top().to(view.safeAreaLayoutGuide, .top),
            Leading(),
            Trailing(),
            Bottom().to(view.safeAreaLayoutGuide, .bottom)
        )
        
        exampleView.easy.layout(
            Top(),
            Leading(),
            Trailing(),
            Height(395),
            Width(UIScreen.main.bounds.width)
        )
        
        serviceView.easy.layout(
            Top(24).to(exampleView, .bottom),
            Leading(16),
            Trailing(16),
            Bottom(),
            Height(300),
            Width(UIScreen.main.bounds.width)
        )
    }
}

extension PortfolioViewController: PortfolioViewType {
    
}
