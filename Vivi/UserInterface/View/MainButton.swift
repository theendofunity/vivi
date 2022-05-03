//
//  MainButton.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 03.05.2022.
//

import UIKit
import EasyPeasy

class MainButton: UIButton {
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
        
        easy.layout(Height(42))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
