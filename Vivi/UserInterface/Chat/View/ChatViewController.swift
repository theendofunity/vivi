//
//  ChatViewController.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 02.05.2022.
//

import UIKit


class ChatViewController: UIViewController {
    weak var presenter: ChatPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

extension ChatViewController: ChatViewType {
    
}
