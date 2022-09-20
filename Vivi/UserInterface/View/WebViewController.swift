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
    private lazy var webView: WKWebView = {
        let view = WKWebView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupConstraints()
    }
    
    func setupView() {
        view.addSubview(webView)
    }
    
    func setupConstraints() {
        webView.easy.layout(
            Top().to(view.safeAreaLayoutGuide, .top),
            Leading(),
            Trailing(),
            Bottom().to(view.safeAreaLayoutGuide, .bottom)
        )
    }
    
    func load(url: URL) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
