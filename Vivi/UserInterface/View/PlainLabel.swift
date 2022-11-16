//
//  PlainLabel.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 03.05.2022.
//

import UIKit

class PlainLabel: UILabel {

    enum FontType {
        case small
        case normal
        case big
    }
    
    init(text: String, fontType: FontType) {
        super.init(frame: .zero)
        
        self.text = text
        self.textColor = .denim
        
        switch fontType {
        case .small:
            self.font = .smallTextFont
        case .normal:
            self.font = .mainFont
        case .big:
            self.font = .titleFont
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
