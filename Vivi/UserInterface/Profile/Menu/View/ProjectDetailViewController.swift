//
//  ProjectDetailViewController.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 05.06.2022.
//

import UIKit
import EasyPeasy

class ProjectDetailViewController: UIViewController {
    var presenter: ProjectDetailPresenter!

    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var headerView: ProfileHeaderView = {
        let header = ProfileHeaderView(position: .left)
        return header
    }()
    
    private lazy var menuView: ProfileMenuView = {
        let view = ProfileMenuView()
        view.delegate = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupView()
        setupConstraints()
        
        presenter?.viewLoaded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter?.viewAppeared()
    }
    
    func setupView() {
        view.backgroundColor = .background

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(headerView)
        
        contentView.addSubview(menuView)

    }
    
    func setupConstraints() {
        scrollView.easy.layout(
            Top().to(view.safeAreaLayoutGuide, .top),
            Leading(),
            Trailing(),
            Bottom().to(view.safeAreaLayoutGuide, .bottom)
        )
        
        contentView.easy.layout(
            Edges(),
            Width().like(scrollView, .width),
            Height(>=0).like(scrollView, .height)
        )
        
        headerView.easy.layout(
            Top(24),
            CenterX(),
            Leading(),
            Trailing()
        )
        
        menuView.easy.layout(
            Top(16).to(headerView, .bottom),
            Leading(),
            Trailing(),
            Bottom(),
            Height(700)
        )
    }

    func setupNavigationBar() {
        navigationBarWithLogo()
        
        let changeButton = UIBarButtonItem(title: "Изменить",
                                           style: .plain,
                                           target: self,
                                           action: #selector(changeButtonPressed))
        navigationItem.rightBarButtonItem = changeButton
    }
    
    @objc func changeButtonPressed() {
        presenter?.changeButtonPressed()
    }
}

extension ProjectDetailViewController: ProfileMenuViewDelegate {
    func menuItemDidSelect(item: ProfileMenuType) {
        presenter.menuItemDidSelect(item: item)
    }
}

extension ProjectDetailViewController: ProjectDetailViewType {
    func setupMenu(items: [ProfileMenuType]) {
        menuView.updateMenu(menuItems: items)
    }
    
    func navigation() -> UINavigationController? {
        return navigationController
    }
    
    func updateHeader(project: ProjectModel) {
        headerView.update(data: project)
    }
}
