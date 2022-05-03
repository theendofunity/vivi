//
//  LineTextField.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 03.05.2022.
//

import UIKit
import EasyPeasy

class LineTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        borderStyle = .none
        let line = UIView()
        line.backgroundColor = .denim
        addSubview(line)
        line.easy.layout(
            Bottom(),
            Leading(),
            Trailing(),
            Height(1)
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
