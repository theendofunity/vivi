//
//  MainButton.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 03.05.2022.
//

import UIKit
import EasyPeasy

class MainButton: UIButton {
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.tintColor = .denim
        indicator.hidesWhenStopped = true
        indicator.isHidden = true
        return indicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .viviRose50
        titleLabel?.font = .mainFont
        setTitleColor(.denim, for: .normal)
        
        round(18)
        layer.shadowColor = UIColor.denim?.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 10)
        layer.shadowRadius = 1
        layer.shadowOpacity = 0.0
        
        addSubview(activityIndicator)
        
        activityIndicator.easy.layout(
            CenterX(),
            CenterY()
        )
        
        easy.layout(Height(50))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showLoading() {
        titleLabel?.alpha = 0
        activityIndicator.startAnimating()
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
        titleLabel?.alpha = 1
    }
    
}
