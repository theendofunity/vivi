//
//  PdfViewController.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 23.05.2022.
//

import UIKit
import EasyPeasy
import WebKit

class DocumentsDetailViewController: UIViewController {
    var url: URL
    
    private lazy var webView: WKWebView = {
        let view = WKWebView()
        return view
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(systemName: "xmark")?.template()
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        button.tintColor = .denim
        return button
    }()
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupConstraints()
        
        load()
    }
    
    func setupView() {
        view.addSubview(webView)
        view.addSubview(closeButton)
    }
    
    func setupConstraints() {
        webView.easy.layout(
            Edges()
        )
        
        closeButton.easy.layout(
            Top(24).to(view.safeAreaLayoutGuide, .top),
            Trailing(24),
            Width(25),
            Height(25)
        )
    }
    
    func load() {
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    @objc func closeView() {
        self.dismiss(animated: true)
    }
}
