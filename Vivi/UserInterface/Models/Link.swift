//
//  Link.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 19.08.2022.
//

import Foundation
import MessageKit

struct Link: LinkItem {
    var text: String?
    
    var attributedText: NSAttributedString?
    
    var url: URL
    
    var title: String?
    
    var teaser: String
    
    var thumbnailImage: UIImage
}
