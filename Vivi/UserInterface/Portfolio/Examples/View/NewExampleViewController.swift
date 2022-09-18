//
//  NewExampleViewController.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 29.08.2022.
//

import UIKit
import EasyPeasy

enum NewExampleSection: Int, CaseIterable {
    case drafts = 0
    case visualisations
    case result
    
    var title: String {
        switch self {
        case .drafts:
            return "Чертежи"
        case .visualisations:
            return "Визуализации"
        case .result:
            return "Результат"
        }
    }
}

class NewExampleViewController: UIViewController {
    var presenter: NewExamplePresenter!
    var selectedSection: NewExampleSection?
    
    var dataSource: UICollectionViewDiffableDataSource<NewExampleSection, ProjectExampleChapterItem>?
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        return scroll
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var titleTextField: TextFieldWithLabel = {
        let model = TextFieldViewModel(type: .title, value: "")
        let textField = TextFieldWithLabel(model: model)
        return textField
    }()
    
    private lazy var descriptionTextField: TextFieldWithLabel = {
        let model = TextFieldViewModel(type: .description, value: "")
        let textField = TextFieldWithLabel(model: model)
        return textField
    }()
    
    private lazy var coverImageLabel: PlainLabel = {
        let label = PlainLabel(text: "Обложка", fontType: .normal)
        return label
    }()
    
    private lazy var coverImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "plus")?.template()
        view.tintColor = .viviRose50
        view.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(coverImageTapped))
        view.addGestureRecognizer(gesture)
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(cell: NewExampleCell.self)
        collection.register(header: TitleHeader.self)
        collection.delegate = self
        collection.backgroundColor = .clear
        collection.isScrollEnabled = false
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupConstraints()
        configureDataSource()
        
        presenter.viewDidLoad()
    }
    
    func setupView() {
        view.backgroundColor = .background
        setupNavigationBar()
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(containerView)
        
        containerView.addSubview(titleTextField)
        containerView.addSubview(descriptionTextField)
        containerView.addSubview(coverImageLabel)
        containerView.addSubview(coverImageView)
        containerView.addSubview(collectionView)
    }
    
    func setupConstraints() {
        let width = UIScreen.main.bounds.width
        
        scrollView.easy.layout(
            Top().to(view.safeAreaLayoutGuide, .top),
            Width(width),
            Leading(),
            Trailing(),
            Bottom().to(view.safeAreaLayoutGuide, .bottom)
        )
        
        containerView.easy.layout(
            Top(),
            Leading(),
            Trailing(),
            Bottom()
        )
        
        titleTextField.easy.layout(
            Top(24),
            Leading(24),
            Trailing(24)
        )
        
        descriptionTextField.easy.layout(
            Top(24).to(titleTextField),
            Leading(24),
            Trailing(24)
        )
        
        coverImageLabel.easy.layout(
            Leading(24),
            Top(24).to(descriptionTextField)
        )
        
        coverImageView.easy.layout(
            Leading(24),
            Trailing(24),
            Top(16).to(coverImageLabel),
            Height(100)
        )
        
        collectionView.easy.layout(
            Top(24).to(coverImageView),
            Leading(24),
            Trailing(24),
            Width(width - 48),
            Bottom()
        )
    }
    
    func setupNavigationBar() {
        navigationBarWithLogo()
        
        let button = UIBarButtonItem(title: "Cохранить",
                                     style: .done,
                                     target: self,
                                     action: #selector(saveButtonPressed))
        navigationItem.rightBarButtonItem = button
    }
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            return self.createSection()
        }
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .estimated(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: "header", alignment: .top)
        header.pinToVisibleBounds = true
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.boundarySupplementaryItems = [header]
        
        layout.configuration = UICollectionViewCompositionalLayoutConfiguration()
        
        return layout
    }
    
    func createSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalWidth(1/3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitem: item,
                                                       count: 2)
        group.interItemSpacing = .fixed(8)
        
        let section = NSCollectionLayoutSection(group: group)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(50.0))

        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: UICollectionView.elementKindSectionHeader,
                                                                 alignment: .top)
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<NewExampleSection, ProjectExampleChapterItem>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewExampleCell.reuseId, for: indexPath) as? NewExampleCell else { return UICollectionViewCell() }
            
            cell.configure(item: itemIdentifier)
            return cell
        })
        dataSource?.supplementaryViewProvider = { collectionView, string, indexPath in
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleHeader.reuseId, for: indexPath) as? TitleHeader else { return UICollectionReusableView() }
            if let section = NewExampleSection(rawValue: indexPath.section) {
                header.configure(title: section.title)
            }
            return header
        }
    }
}

extension NewExampleViewController: NewExampleViewType {
    func showSuccess() {
        showAlert(title: "Мяк!", message: "Новый пример проекта добавлен")
        navigationController?.popViewController(animated: true)
    }
    
    func showError(error: Error) {
        alertError(error: error)
    }
    
    func updateCover(image: UIImage) {
        coverImageView.image = image
    }
    
    @objc func saveButtonPressed() {
        guard let title = titleTextField.text(),
              let description = descriptionTextField.text() else { return }
        presenter.saveButtonPressed(title: title, description: description)
    }
    
    func update(model: ProjectExample) {
        var snapshot = NSDiffableDataSourceSnapshot<NewExampleSection, ProjectExampleChapterItem>()
        snapshot.appendSections(NewExampleSection.allCases)
        
        snapshot.appendItems(model.drafts.images, toSection: .drafts)
        snapshot.appendItems(model.visualisations.images, toSection: .visualisations)
        snapshot.appendItems(model.result.images, toSection: .result)

        
        dataSource?.apply(snapshot)
        
        let itemsHeight: CGFloat = 70
        collectionView.easy.layout(Height(CGFloat(model.numberOfItems) * itemsHeight + 300.0))
    }
    
    @objc func coverImageTapped() {
        showPicker()
    }
}

extension NewExampleViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? NewExampleCell else { return }
        if cell.item?.type == .empty {
            selectedSection = NewExampleSection(rawValue: indexPath.section)
            showPicker()
        }
    }
    
    func showPicker() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.mediaTypes = ["public.image"]
        present(picker, animated: true)
    }
}

extension NewExampleViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.originalImage] as? UIImage else { return }
        
        if let section = selectedSection {
            presenter.addImage(image: image, section: section)
            selectedSection = nil
        } else {
            presenter.addImageToCover(image: image)
        }
    }
}
