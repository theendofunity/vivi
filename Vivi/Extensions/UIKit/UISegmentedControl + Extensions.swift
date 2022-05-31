//
//  UISegmentedControl + Extensions.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 31.05.2022.
//

import UIKit

extension UISegmentedControl {
    func setNumberOfLines(_ num: Int) {
        for segmentItem in self.subviews {
            for item in segmentItem.subviews {
                if let i = item as? UILabel {
                    i.numberOfLines = num
                }
            }
        }
    }
}
