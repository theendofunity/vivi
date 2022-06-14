//
//  ChatDetailViewController.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 14.06.2022.
//

import UIKit
import MessageKit

class ChatDetailViewController: MessagesViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
//
//extension ChatDetailViewController: MessagesDataSource {
//    func currentSender() -> SenderType {
//        <#code#>
//    }
//
//    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
//        <#code#>
//    }
//    
//    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
//        return 1
//    }
//
//
//}

extension ChatDetailViewController: MessagesLayoutDelegate {
    
}

extension ChatDetailViewController: MessagesDisplayDelegate {
    
}
