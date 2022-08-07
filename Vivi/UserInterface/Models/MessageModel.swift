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
    enum MediaType: Int {
        case none = 0
        case image
        case video
    }
    
    var id: String? = nil
    var sender: SenderType
    var sentDate: Date
    var avatarUrl: String?

    var content: String?
    var image: UIImage? = nil
    var imageUrl: URL? = nil
    var mediaType: MediaType = .none
    
    var messageId: String {
        return id ?? UUID().uuidString
    }
    
    var kind: MessageKind {
        if let url = imageUrl {
            let mediaItem = ImageItem(url: url,
                                      image: nil,
                                      placeholderImage: UIImage(),
                                      size: CGSize(width: 500, height: 500))
            switch mediaType {
            case .none:
                return .text(content ?? "")
            case .image:
                return .photo(mediaItem)
            case .video:
                return .video(mediaItem)
            }
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
        
        if let mediaType = document["mediaType"] as? Int {
            self.mediaType = MediaType(rawValue: mediaType) ?? .none
        }
        
        if let avatarUrl = document["avatarUrl"] as? String {
            self.avatarUrl = avatarUrl
        }
        
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
    
    init(sender: UserModel, image: URL) {
        self.sender = sender
        self.imageUrl = image
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
            "imageUrl" : imageUrl?.absoluteString ?? "",
            "content" : content ?? "",
            "avatarUrl" : avatarUrl ?? "",
            "mediaType" : mediaType.rawValue 
        ]
        return dict
    }
}
