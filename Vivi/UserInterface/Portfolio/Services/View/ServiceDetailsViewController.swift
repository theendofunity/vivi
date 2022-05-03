//
//  ServiceDetailsViewController.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 03.05.2022.
//

import UIKit
import EasyPeasy

class ServiceDetailsViewController: UIViewController {
    let serviceType: ServiceType
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(systemName: "xmark")?.template()
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var infoView: UIView = {
        let view = UIView()
        view.backgroundColor = .background
        view.round(18)
        
        return view
    }()
    
    private lazy var infoStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 30
        
        return stack
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .smallTextFont
        label.textColor = .denim
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var orderButton: MainButton = {
        let button = MainButton()
        button.setTitle("Заказать", for: .normal)
        return button
    }()
    
    init(serviceType: ServiceType) {
        self.serviceType = serviceType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        self.setupConstraints()
    }
    
    func setupView() {
        priceLabel.text = serviceType.priceTitle()
        fillTitles()
        imageView.image = serviceType.image()
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(infoView)
        
        infoView.addSubview(infoStack)
        infoView.addSubview(priceLabel)
        infoView.addSubview(orderButton)
        scrollView.addSubview(closeButton)
        
       
    }
    
    func setupConstraints() {
        scrollView.easy.layout(
           Edges()
        )
        
        closeButton.easy.layout(
            Top(24),
            Trailing(24),
            Width(25),
            Height(25)
        )
        
        imageView.easy.layout(
            Top(),
            Leading(),
            Trailing(),
            Height(370)
        )
        
        infoView.easy.layout(
            Top(320),
            Leading(),
            Trailing(),
            Bottom(),
            Width(UIScreen.main.bounds.width)
        )
        
        infoStack.easy.layout(
            Top(24),
            Leading(24),
            Trailing(24)
        )
        
        priceLabel.easy.layout(
            Top(24).to(infoStack, .bottom),
            CenterX()
        )
        
        orderButton.easy.layout(
            Top(24).to(priceLabel),
            Leading(24),
            Trailing(24),
            Bottom(24)
        )
    }
    
    func fillTitles() {
        for title in serviceType.titles() {
            let label = UILabel()
            label.text = title
            label.font = .smallTextFont
            label.textColor = .denim
            label.numberOfLines = 0
            infoStack.addArrangedSubview(label)
        }
    }
    
    @objc func closeView() {
        self.dismiss(animated: true)
    }
}
