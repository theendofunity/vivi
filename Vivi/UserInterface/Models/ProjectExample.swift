//
//  ProjectExample.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 28.08.2022.
//

import Foundation
import UIKit

struct ProjectExampleChapterItem: Hashable {
    let id = UUID()
    enum ItemType {
        case filled
        case empty
    }
    
    var type: ItemType = .empty
    
    var image: UIImage? {
        get {
            if type == .empty {
                return UIImage(systemName: "plus")?.template()
            } else {
                return realImage
            }
        }
        set {
            self.realImage = newValue
            self.type = .filled
        }
        
    }
    private var realImage: UIImage?
    
    static func == (rhs: ProjectExampleChapterItem, lhs: ProjectExampleChapterItem) -> Bool {
        return rhs.id == lhs.id
    }
}

struct ProjectExampleChapter: FirestoreSavable, Hashable {
    init() {
        title = ""
        description = ""
        urls = []
        images = [ProjectExampleChapterItem()]
    }
    init?(document: [String : Any]) {
        guard let title = document["title"] as? String else { return nil }
        
        self.title = title
        description = document["description"] as? String ?? ""
        urls = document["urls"] as? [String] ?? []
        images = []
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
    var images: [ProjectExampleChapterItem] = [ProjectExampleChapterItem()]
    var urls: [String] = []
}

struct ProjectExample: FirestoreSavable {
    var title: String
    var description: String?
    var titleImageUrl: String?
    var titleImage: UIImage?
    var visualisations: ProjectExampleChapter = ProjectExampleChapter()
    var drafts: ProjectExampleChapter = ProjectExampleChapter()
    var result: ProjectExampleChapter = ProjectExampleChapter()
    
    init?(document: [String : Any]) {
        guard let title = document["title"] as? String else { return nil }
        
        self.title = title
        description = document["description"] as? String ?? ""
        titleImageUrl = document["titleImageUrl"] as? String ?? ""

        if let visualisations = document["visualisations"] as? [String : Any] {
            self.visualisations = ProjectExampleChapter(document: visualisations) ?? ProjectExampleChapter()
        }
        
        if let drafts = document["drafts"] as? [String : Any] {
            self.drafts = ProjectExampleChapter(document: drafts) ?? ProjectExampleChapter()
        }
        
        if let result = document["result"] as? [String : Any] {
            self.result = ProjectExampleChapter(document: result) ?? ProjectExampleChapter()
        }
    }
    
    init() {
        title = ""
        description = ""
    }
    
    func documentId() -> String? {
        return title
    }
    
    func representation() -> [String : Any] {
        let dict: [String : Any] = [
            "title" : title,
            "description" : description ?? "",
            "titleImageUrl" : titleImageUrl ?? "",
            "visualisations" : visualisations.representation(),
            "drafts" : drafts.representation(),
            "result" : result.representation()
        ]
        return dict
    }
    
    var numberOfItems: Int {
        return visualisations.images.count + drafts.images.count + result.images.count
    }
}

extension ProjectExample: Hashable {
    static func == (lhs: ProjectExample, rhs: ProjectExample) -> Bool {
        return lhs.title == rhs.title && lhs.description == rhs.description
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
}
