//
//  ChatDetailViewController.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 14.06.2022.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class ChatDetailViewController: MessagesViewController {
    var presenter: ChatDetailsPresenter?
    var messages: [MessageModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        messageInputBar.delegate = self
        
        presenter?.viewDidLoad()
    }

    
    
//    func insertNewMessage(message: MessageModel) {
//
//    }
}

extension ChatDetailViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        return presenter!.currentSender
    }

    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }


}

extension ChatDetailViewController: MessagesLayoutDelegate {
    
}

extension ChatDetailViewController: MessagesDisplayDelegate {
    
}

extension ChatDetailViewController: ChatDetailViewType {
    func showError(error: Error) {
        alertError(error: error)
    }
    
    func update(messages: [MessageModel]) {
        self.messages = messages
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToLastItem(at: .bottom, animated: true)
    }
}

extension ChatDetailViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        inputBar.inputTextView.text = ""
        presenter?.sendMessage(text: text)
    }
}
