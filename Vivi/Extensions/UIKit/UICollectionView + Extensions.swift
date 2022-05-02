//
//  UICollectionView + Extensions.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 02.05.2022.
//

import UIKit

extension UICollectionView {
    func register(cell: ReusableView.Type) {
        register(cell.self, forCellWithReuseIdentifier: cell.reuseId)
    }
}
