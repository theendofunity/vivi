//
//  UIFont + Extensions.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 02.05.2022.
//

import UIKit

extension UIFont {
    static var titleFont: UIFont? {
        return UIFont.systemFont(ofSize: 32)
    }
    
    static var subtitleFont: UIFont? {
        return UIFont.systemFont(ofSize: 24)
    }
    
    static var mainFont: UIFont? {
        return UIFont.systemFont(ofSize: 22)
    }
    
    static var smallTextFont: UIFont? {
        return UIFont.systemFont(ofSize: 18)
    }
    
    static var errorFont: UIFont? {
        return UIFont.systemFont(ofSize: 12)
    }
}
