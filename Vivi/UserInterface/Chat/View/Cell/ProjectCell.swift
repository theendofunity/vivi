//
//  ProjectCell.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 09.06.2022.
//

import UIKit

class ProjectCell: ReusableCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        backgroundColor = .red
    }
    
    func setupConstraints() {
        
    }

}
