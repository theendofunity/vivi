//
//  WebViewController.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 20.09.2022.
//

import UIKit
import WebKit
import EasyPeasy

class WebViewController: UIViewController, WKUIDelegate {
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(systemName: "xmark")?.template()
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        button.tintColor = .viviRose
        return button
    }()
    
    private lazy var webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        let view = WKWebView(frame: .zero, configuration: webConfiguration)
        view.uiDelegate = self
        view.navigationDelegate = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupConstraints()
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
            Top(60).to(view.safeAreaLayoutGuide, .top),
            Trailing(24),
            Width(25),
            Height(25)
        )
    }
    
    func load(url: URL) {
        let request = URLRequest(url: url)
        webView.load(request)

    }
    
    @objc func closeView() {
        self.dismiss(animated: true)
    }
}

extension WebViewController: WKNavigationDelegate {}
