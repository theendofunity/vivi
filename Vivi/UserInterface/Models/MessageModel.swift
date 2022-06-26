//
//  MessageModel.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 06.06.2022.
//

import Foundation
import MessageKit
import FirebaseFirestore

struct MessageModel: MessageType {
    var id: String? = nil
    var sender: SenderType
    var sentDate: Date

    var content: String?
    var image: UIImage? = nil
    var imageUrl: URL? = nil
    
    var messageId: String {
        return id ?? UUID().uuidString
    }
    
    var kind: MessageKind {
        if let image = image {
            let mediaItem = ImageItem(url: nil, image: nil, placeholderImage: image, size: image.size)
            return .photo(mediaItem)
        }
        return .text(content ?? "")
    }
}

extension MessageModel: FirestoreSavable {
    init?(document: [String : Any]) {
        guard let sentDate = document["sentDate"] as? Timestamp,
              let id = document["id"] as? String,
              let name = document["senderName"] as? String,
              let senderId = document["senderId"] as? String
        else { return nil }
        
        self.sender = SenderModel(senderId: senderId, displayName: name)
        self.sentDate = sentDate.dateValue()
        self.id = id
        
        if let imageUrl = document["imageUrl"] as? String,
           !imageUrl.isEmpty {
            self.imageUrl = URL(string: imageUrl)
            self.content = ""
        } else if let content = document["content"] as? String{
            self.content = content
        } else {
            return nil
        }
    }
    
    init(sender: UserModel, content: String) {
        self.sender = sender
        self.content = content
        self.sentDate = Date()
    }
    
    func documentId() -> String? {
        return messageId
    }
    
    func representation() -> [String : Any] {
        let dict: [String : Any] = [
            "sentDate" : sentDate,
            "senderName" : sender.displayName,
            "senderId" : sender.senderId,
            "id" : messageId,
            "imageUrl" : imageUrl ?? "",
            "content" : content
        ]
        return dict
    }
    
    
}
