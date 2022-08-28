//
//  ProjectExample.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 28.08.2022.
//

import Foundation
import UIKit

struct ProjectExampleChapter: FirestoreSavable {
    init?(document: [String : Any]) {
        guard let title = document["title"] as? String else { return nil }
        
        self.title = title
        description = document["description"] as? String ?? ""
        urls = document["urls"] as? [String] ?? []
    }
    
    func documentId() -> String? {
        return title
    }
    
    func representation() -> [String : Any] {
        let dict: [String : Any] = [
            "title" : title,
            "description" : description ?? "",
            "urls" : urls
        ]
        return dict
    }
    
    var title: String
    var description: String?
    var images: [UIImage]?
    var urls: [String] = []
}

struct ProjectExample: FirestoreSavable {
    init?(document: [String : Any]) {
        guard let title = document["title"] as? String else { return nil }
        
        self.title = title
        description = document["description"] as? String ?? ""
        titleImageUrl = document["titleImageUrl"] as? String ?? ""

        if let visualisations = document["visualisations"] as? [String : Any] {
            self.visualisations = ProjectExampleChapter(document: visualisations)
        }
        
        if let drafts = document["drafts"] as? [String : Any] {
            self.drafts = ProjectExampleChapter(document: drafts)
        }
        
        if let result = document["result"] as? [String : Any] {
            self.result = ProjectExampleChapter(document: result)
        }
    }
    
    func documentId() -> String? {
        return title
    }
    
    func representation() -> [String : Any] {
        let dict: [String : Any] = [
            "title" : title,
            "description" : description ?? "",
            "titleImageUrl" : titleImageUrl ?? "",
            "visualisations" : visualisations?.representation() ?? [:],
            "drafts" : drafts?.representation() ?? [:],
            "result" : result?.representation() ?? [:]
        ]
        return dict
    }
    
    var title: String
    var description: String?
    var titleImageUrl: String?
    var visualisations: ProjectExampleChapter?
    var drafts: ProjectExampleChapter?
    var result: ProjectExampleChapter?
}
