//
//  ChatDetailsPresenter.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 15.06.2022.
//

import Foundation
import FirebaseFirestore
import SwiftLoader
import AVKit
import AVFoundation

protocol ChatDetailViewType: AnyObject {
    func update(messages: [MessageModel])
    func showError(error: Error)
    func setTitle(title: String)
    func navigation() -> UINavigationController?
}

class ChatDetailsPresenter {
    weak var view: ChatDetailViewType?
    
    var chat: ChatModel
    var messages: [MessageModel] = []
    var currentSender: UserModel
    
    var listener: ListenerRegistration?
    var storage = ChatService.shared
    
    init(chat: ChatModel, currentUser: UserModel) {
        self.chat = chat
        self.currentSender = currentUser
    }
    
    deinit {
        listener?.remove()
    }
    
     func viewDidLoad() {
         addListener()
         setTitle()
    }
    
    func viewDidAppear() {
        
    }
    
    func readAllMessages() {
        guard let user = UserService.shared.user else { return }
        
        chat.lastMessage = messages.last
        
        for message in messages.reversed() {
            if !message.isReaded(by: user.id) {
                ChatService.shared.readMessage(message: message)
                ChatService.shared.updateLastMessage(chat: chat)
            } else {
                break //read untin new messages
            }
        }
    }
    
    func addListener() {
        listener = storage.addMessagesObserver(chatId: chat.id, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let messages):
                let filtredMessages = messages.filter { newMessage in
                    !self.messages.contains(where: { oldMessage in
                        oldMessage.id == newMessage.id
                    })
                } .sorted { $0.sentDate < $1.sentDate }
                
                if !filtredMessages.isEmpty {
                    self.messages.append(contentsOf: filtredMessages)
                    self.view?.update(messages: self.messages)
                    self.readAllMessages()
                }
            case .failure(let error):
                self.view?.showError(error: error)
            }
        })
    }
    
    func setTitle() {
        view?.setTitle(title: chat.displayTitle())
        
        guard let userId = chat.users.first(where: { $0 != currentSender.id }) else { return }
        
        FirestoreService.shared.loadUser(userId: userId) { [weak self] result in
            switch result {
            case .success(let user):
                self?.view?.setTitle(title: user.displayName)
            default:
                break
            }
        }
    }
}

extension ChatDetailsPresenter {
    func sendMessage(text: String) {
        var message = MessageModel(sender: currentSender, content: text)
        message.avatarUrl = currentSender.avatarUrl
                
        sendMessage(message: message)
        
    }
    
    func sendMessage(message: MessageModel) {
        var message = message
        message.chatID = chat.id
        chat.lastMessage = message
        
        storage.sendMessage(chat: chat) { [weak self] result in
            switch result {
            case .success():
                break
            case .failure(let error):
                self?.view?.showError(error: error)
            }
        }
    }
    
    func sendMessage(imageUrl: URL) {
        SwiftLoader.show(animated: true)
        
        StorageService.shared.saveImage(imageUrl: imageUrl, referenceType: .chatMedia) { [weak self] result in
            SwiftLoader.hide()
            switch result {
            case .success(let url):
                guard let self = self else { return }
                var message = MessageModel(sender: self.currentSender, url: url)
                message.mediaType = .image
                message.avatarUrl = self.currentSender.avatarUrl
                self.sendMessage(message: message)
            case .failure(let error):
                self?.view?.showError(error: error)
            }
        }
    }
    
    func sendData(data: URL, type: MessageModel.MediaType) {
        SwiftLoader.show(animated: true)
        
        StorageService.shared.saveData(imageUrl: data, referenceType: .chatMedia) { [weak self] result in
            SwiftLoader.hide()
            data.stopAccessingSecurityScopedResource()
            switch result {
            case .success(let url):
                guard let self = self else { return }
                var message = MessageModel(sender: self.currentSender, url: url)
                message.mediaType = type
                message.avatarUrl = self.currentSender.avatarUrl
                self.sendMessage(message: message)
            case .failure(let error):
                self?.view?.showError(error: error)
            }
        }
    }
    
    func openImage(url: URL) {
        let view = DetailImageViewController()
        view.modalPresentationStyle = .fullScreen
        self.view?.navigation()?.present(view, animated: true, completion: {
            view.update(urls: [url], selectedIndex: IndexPath(item: 0, section: 0))
        })
    }
    
    func openVideo(url: URL) {
        let player = AVPlayerViewController()
        player.player = AVPlayer(url: url)
        view?.navigation()?.present(player, animated: true)
    }
    
    func openLink(url: URL) {
        let view = DocumentsDetailViewController(url: url)
        self.view?.navigation()?.present(view, animated: true)
    }
    
    func showImageConfirm(url: URL) {
        let confirmView = ConfirmImageSendingViewController()
        confirmView.delegate = self
        confirmView.configure(imageUrl: url)
        confirmView.modalPresentationStyle = .popover
        view?.navigation()?.present(confirmView, animated: true)
    }
}

extension ChatDetailsPresenter: ConfirmSendingImageDelegate {
    func sendButtonPressed(imageUrl: URL) {
        sendMessage(imageUrl: imageUrl)
    }
}
