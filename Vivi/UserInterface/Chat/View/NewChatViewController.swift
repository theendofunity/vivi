//
//  NewChatViewController.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 09.06.2022.
//

import UIKit
import EasyPeasy

class NewChatViewController: UIViewController {
    enum Section: Int, CaseIterable {
        case projects = 0
        case users = 1
    }
    
    enum Item: Hashable {
        case project(ProjectModel)
        case user(UserModel)
    }
    
    var presenter: NewChatPresenter!
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    
    var projects: [ProjectModel] = []
    var users: [UserModel] = []
    
    private lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(cell: UserCell.self)
        collectionView.register(cell: ProjectCell.self)

        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        collectionView.delegate = self
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupConstraints()
        
        setupDataSource()
        
        presenter.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.viewDidAppear()
    }
    
    func setupView() {
        view.backgroundColor = .background
        view.addSubview(collectionView)
    }
    
    func setupConstraints() {
        collectionView.easy.layout(
            Top().to(view.safeAreaLayoutGuide, .top),
            Leading(),
            Trailing(),
            Bottom().to(view.safeAreaLayoutGuide, .bottom)
        )
    }
    
    func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            if indexPath.section == Section.users.rawValue {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserCell.reuseId, for: indexPath) as? UserCell else { return UICollectionViewCell() }
                switch itemIdentifier {
                case .user(let user):
                    cell.configure(user: user)
                default:
                    break
                }
                return cell
            } else {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProjectCell.reuseId, for: indexPath) as? ProjectCell else { return UICollectionViewCell() }
                
                switch itemIdentifier {
                case .project(let project):
                    cell.configure(project: project)
                default:
                    break
                }
                return cell
            }
        })
    }
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { index, environment in
            if index == Section.projects.rawValue {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                      heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                       heightDimension: .fractionalWidth(0.6))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                               subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                
                return section
            } else {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                      heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                       heightDimension: .absolute(80))
                let group: NSCollectionLayoutGroup = .vertical(layoutSize: groupSize,
                                                               subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = .init(top: 0, leading: 24, bottom: 0, trailing: 24)

                return section
            }
        }
        
        return layout
    }
    
    func reload() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(Section.allCases)
        
        let usersItems = users.map { Item.user($0) }
        snapshot.appendItems(usersItems, toSection: .users)
        
        let projectsItems = projects.map { Item.project($0) }
        snapshot.appendItems(projectsItems, toSection: .projects)
        
        dataSource?.apply(snapshot)
    }
}

extension NewChatViewController: NewChatViewType {
    func showError(error: Error) {
        alertError(error: error)
    }
    
    func setup(users: [UserModel]) {
        self.users = users
        reload()
    }
    
    func setup(projects: [ProjectModel]) {
        self.projects = projects
        reload()
    }
}

extension NewChatViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section) else { return }
        
        switch section {
        case .users:
            let user = users[indexPath.item]
            presenter.userDidSelect(user: user)
        case .projects:
            let project = projects[indexPath.item]
            presenter.projectDidSelect(project: project)
        }
    }
}
