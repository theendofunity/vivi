//
//  TextMenuViewController.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 22.05.2022.
//

import UIKit
import EasyPeasy

class TextMenuViewController: UIViewController {
    var presenter: TextMenuPresenterProtocol!
    var files: [String] = []
    
    private lazy var mainButton: MainButton = {
        let button = MainButton()
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let width = UIScreen.main.bounds.width - 48
        layout.itemSize = CGSize(width: width, height: 60)
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.showsVerticalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.register(cell: TextMenuCell.self)
        collection.delegate = self
        collection.dataSource = self
        collection.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 50, right: 0)
        
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBarBase()
        
        setupView()
        setupConstraints()
        
        presenter.viewDidLoad()
    }
    
    func setupView() {
        view.backgroundColor = .background
        view.addSubview(collectionView)
        view.addSubview(mainButton)
    }
    
    func setupConstraints() {
        collectionView.easy.layout(
            Top().to(view.safeAreaLayoutGuide, .top),
            Leading(24),
            Trailing(24),
            Bottom().to(view.safeAreaLayoutGuide, .bottom)
        )
        
        mainButton.easy.layout(
            Bottom(24).to(view.safeAreaLayoutGuide, .bottom),
            Leading(24),
            Trailing(24)
        )
    }
    
    @objc func buttonPressed() {
        presenter.buttonPressed()
    }
}

extension TextMenuViewController: TextMenuViewType {
    func navigation() -> UINavigationController? {
        return navigationController
    }
    
    func setupFiles(files: [String]) {
        self.files = files
        collectionView.reloadData()
    }
    
    func showError(error: Error) {
        alertError(error: error)
    }
    
    func setupTitle(_ title: String) {
        navigationItem.title = title
    }
    
    func setupButton(title: String, isHidden: Bool) {
        mainButton.setTitle(title, for: .normal)
        mainButton.isHidden = isHidden
    }
    
    func selectFile() {
        let picker = UIDocumentPickerViewController(documentTypes: ["public.text", "public.content"], in: .import)
        picker.delegate = self
        picker.allowsMultipleSelection = false
        present(picker, animated: true)
    }
}

extension TextMenuViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return files.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextMenuCell.reuseId, for: indexPath) as? TextMenuCell else { return UICollectionViewCell() }
        let title = files[indexPath.item]
        cell.configure(title: title)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let file = files[indexPath.item]
        presenter.fileDidSelect(filename: file)
    }
}

extension TextMenuViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard controller.documentPickerMode == .import,
              let url = urls.first else { return }
        
        presenter.add(file: url)
    }
}
