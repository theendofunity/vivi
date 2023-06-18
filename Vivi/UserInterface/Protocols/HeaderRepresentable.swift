//
//  HeaderRepresentable.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 06.06.2022.
//

import Foundation

protocol HeaderRepresentable: Hashable {
    func headerTitle() -> String
    func addressTitle() -> String
    func imageUrl() -> URL?
}
