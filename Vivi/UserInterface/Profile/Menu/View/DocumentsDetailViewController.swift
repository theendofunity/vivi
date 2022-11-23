//
//  PdfViewController.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 23.05.2022.
//

import UIKit
import EasyPeasy
import PDFKit
import SwiftLoader

class DocumentsDetailViewController: UIViewController {
    var url: URL
    
    private lazy var pdfView: PDFView = {
        let view = PDFView()
        view.autoScales = true
        return view
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(systemName: "xmark")?.template()
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square.and.arrow.down"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
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
        view.addSubview(pdfView)
        view.addSubview(closeButton)
        view.addSubview(saveButton)
    }
    
    func setupConstraints() {
        pdfView.easy.layout(
            Edges()
        )
        
        closeButton.easy.layout(
            Top(24).to(view.safeAreaLayoutGuide, .top),
            Trailing(24),
            Width(25),
            Height(25)
        )
        
        saveButton.easy.layout(
            Top(24).to(view.safeAreaLayoutGuide, .top),
            Leading(24),
            Width(25),
            Height(25)
        )
    }
    
    func load() {
        DispatchQueue.global().async {
            if let document = PDFDocument(url: self.url) {
                DispatchQueue.main.async {
                    self.pdfView.document = document
                    
                }
            }
        }
    }
    
    @objc func closeView() {
        self.dismiss(animated: true)
    }
    
    @objc func saveButtonPressed() {
        UIImpactFeedbackGenerator().impactOccurred()

        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        let documentName = url.lastPathComponent
        let path = documentsDirectory.appendingPathComponent(documentName)
        
        pdfView.document?.write(to: path)

        let alert = UIAlertController(title: "Cохранено", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ок", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
}
