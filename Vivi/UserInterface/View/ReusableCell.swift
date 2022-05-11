//
//  ReusableCell.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 02.05.2022.
//

import UIKit

protocol ReusableView: AnyObject {
    static var reuseId: String { get }
}

extension ReusableView {
    static var reuseId: String {
        return NSStringFromClass(self)
    }
}

class ReusableSupplementaryView: UICollectionReusableView, ReusableView {}

class ReusableCell: UICollectionViewCell, ReusableView {}
