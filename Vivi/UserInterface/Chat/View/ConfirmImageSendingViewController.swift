//
//  ConfirmImageSendingView.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 25.07.2022.
//

import UIKit
import EasyPeasy

protocol ConfirmSendingImageDelegate: AnyObject {
    func sendButtonPressed(image: UIImage)
}

class ConfirmImageSendingViewController: UIViewController {
    weak var delegate: ConfirmSendingImageDelegate?
    
    private var url: URL?
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .background
        view.round(16)
        return view
    }()
    
    private lazy var titleLabel: PlainLabel = {
        let label = PlainLabel(text: "Подтверждение выбора", fontType: .normal)
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton()
        button.setTitle("Отправить", for: .normal)
        button.setTitleColor(UIColor.viviRose, for: .normal)
        button.setImage(UIImage(systemName: "paperplane"), for: .normal)
        button.imageView?.tintColor = .viviRose
        button.addTarget(self, action: #selector(sendButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(UIColor.denim, for: .normal)
        button.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [cancelButton, sendButton])
        stack.axis = .horizontal
        stack.spacing = 16
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupConstraints()
    }
    
    func setupView() {
        view.backgroundColor = .clear
        
        view.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(imageView)
        contentView.addSubview(buttonsStack)
    }
    
    func setupConstraints() {
        contentView.easy.layout(
            Bottom(),
            Leading(),
            Trailing()
        )
        
        titleLabel.easy.layout(
            Top(16),
            CenterX()
        )
        imageView.easy.layout(
            Top(24).to(titleLabel, .bottom),
            Leading(24),
            Trailing(24),
            Height(300)
        )
        
        buttonsStack.easy.layout(
            Top(40).to(imageView, .bottom),
            CenterX(),
            Bottom(24).to(view.safeAreaLayoutGuide, .bottom)
        )
    }

    @objc func sendButtonPressed() {
        guard let image = imageView.image else { return }
        delegate?.sendButtonPressed(image: image)
        dismiss(animated: true)
    }
    
    @objc func cancelButtonPressed() {
        dismiss(animated: true)
    }
    
    func configure(image: UIImage) {
        imageView.image = image
    }
}
