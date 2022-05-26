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
        textColor = .denim
        
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
    
    override var placeholder: String? {
        didSet {
            if let color = UIColor.denim?.withAlphaComponent(0.5),
            let text = placeholder {
                attributedPlaceholder = NSAttributedString(
                    string: text,
                    attributes: [NSAttributedString.Key.foregroundColor: color]
                )
            }
            
        }
    }
}
