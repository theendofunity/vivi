//
//  ChatDetailViewController.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 14.06.2022.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import EasyPeasy
import UniformTypeIdentifiers

class ChatDetailViewController: MessagesViewController {
    var presenter: ChatDetailsPresenter?
    var messages: [MessageModel] = []
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .background
        return view
    }()
    
    private lazy var mediaButton: InputBarButtonItem = {
        let button = InputBarButtonItem()
        button.setImage(UIImage(systemName: "paperclip"), for: .normal)
        button.setSize(CGSize(width: 40, height: 40), animated: false)
        button.onTouchUpInside({ [weak self] _ in
            self?.mediaButtonPressed()
        })
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(backgroundView)
        let height = navigationController?.navigationBar.frame.height ?? 100
        backgroundView.easy.layout(Top(0), Leading(), Trailing(), Height(height))

        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messageCellDelegate = self
        messageInputBar.delegate = self
        
        setupView()
        
        presenter?.viewDidLoad()
    }
    
    func setupView() {
        navigationBarBase()
        navigationController?.navigationBar.isOpaque = true
        view.backgroundColor = .background
        messagesCollectionView.backgroundColor = .background
        
        scrollsToLastItemOnKeyboardBeginsEditing = true
        showMessageTimestampOnSwipeLeft = true
       
        setupInputBar()
    }

    func setupInputBar() {
        messageInputBar.contentView.backgroundColor = .clear
        messageInputBar.backgroundView.backgroundColor = .viviLightBlue
        messageInputBar.tintColor = .viviRose
        messageInputBar.backgroundColor = .background
        messageInputBar.inputTextView.textColor = .denim
        messageInputBar.inputTextView.backgroundColor = .background

        
        messageInputBar.sendButton.setTitle("", for: .normal)
        messageInputBar.sendButton.setImage(UIImage(systemName: "paperplane"), for: .normal)
        messageInputBar.sendButton.setSize(CGSize(width: 40, height: 40), animated: false)
        messageInputBar.sendButton.backgroundColor = .clear
        
        messageInputBar.inputTextView.layer.borderWidth = 1
        messageInputBar.inputTextView.layer.borderColor = UIColor.denim?.cgColor
        messageInputBar.rightStackView.backgroundColor = .clear
        messageInputBar.separatorLine.backgroundColor = .viviLightBlue
        messageInputBar.middleContentViewPadding = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        messageInputBar.topStackView.backgroundColor = .viviLightBlue
        messageInputBar.inputTextView.round(8)
        
        messageInputBar.setStackViewItems([mediaButton], forStack: .left, animated: false)
        messageInputBar.setLeftStackViewWidthConstant(to: 40, animated: false)
    }
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
       func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
           return 20
       }
}

extension ChatDetailViewController: MessagesDisplayDelegate {
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        if isFromCurrentSender(message: message) {
            return .viviLightRose!
        } else {
            return .denim!
        }
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return .white
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        return .bubble
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
            let name = message.sender.displayName
            return NSAttributedString(string: name,
                                      attributes: [
                                        .foregroundColor : UIColor.denim!
                                      ])
        }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        guard let message = message as? MessageModel else { return }
        avatarView.sd_setImage(with: URL(string: message.avatarUrl ?? ""))
    }
    
    func configureMediaMessageImageView(_ imageView: UIImageView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        guard let message = message as? MessageModel else { return }
        imageView.sd_setImage(with: message.dataUrl)
    }
}

extension ChatDetailViewController: ChatDetailViewType {
    func navigation() -> UINavigationController? {
        return navigationController
    }
    
    func setTitle(title: String) {
        self.title = title
    }
    
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

extension ChatDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func mediaButtonPressed() {
        let alert = UIAlertController(title: "Выберите тип", message: "", preferredStyle: .actionSheet)
        let mediaAction = UIAlertAction(title: "Медиа", style: .default) { _ in
            self.showImagePicker()
        }
        
        let fileAction = UIAlertAction(title: "Файл", style: .default) { _ in
            self.showFilePicker()
        }
        
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel)
        
        alert.addAction(mediaAction)
        alert.addAction(fileAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func showImagePicker() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.mediaTypes = ["public.image", "public.movie"]
        present(picker, animated: true)
    }
    
    func showFilePicker() {
        let types = [UTType.pdf]
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: types)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let type = info[.mediaType] as? String else { return }
        
        if type == "public.image" {
            guard let image = info[.originalImage] as? UIImage else { return }
            dismiss(animated: true)
            showConfirmSending(image: image)
        } else if type == "public.movie" {
            guard let url = info[.mediaURL] as? URL else { return }
            dismiss(animated: true)
            presenter?.sendData(data: url, type: .video)
        }
    }
    
    func showConfirmSending(image: UIImage) {
        presenter?.showImageConfirm(image: image)
    }
}

extension ChatDetailViewController: MessageCellDelegate {
    func didTapImage(in cell: MessageCollectionViewCell) {
        guard let indexPath = messagesCollectionView.indexPath(for: cell),
              let message = messagesCollectionView.messagesDataSource?.messageForItem(at: indexPath,
                                                                                      in: messagesCollectionView)
        else { return }
        
        switch message.kind {
        case .photo(let media):
            guard let url = media.url else { return }
            presenter?.openImage(url: url)
        case .video(let media):
            guard let url = media.url else { return }
            presenter?.openVideo(url: url)
        default:
            break
        }
    }
    
    func didTapMessage(in cell: MessageCollectionViewCell) {
        guard let indexPath = messagesCollectionView.indexPath(for: cell),
              let message = messagesCollectionView.messagesDataSource?.messageForItem(at: indexPath,
                                                                                      in: messagesCollectionView)
        else { return }
        
        switch message.kind {
        case .linkPreview(let link):
            presenter?.openLink(url: link.url)
        default:
            break
        }
    }
}

extension ChatDetailViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        dismiss(animated: true)
        guard let url = urls.first,
        url.startAccessingSecurityScopedResource() else { return }
        presenter?.sendData(data: url, type: .file)
    }
}

