//
//  ProfilePagerViewController.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 12.05.2022.
//

import UIKit
import EasyPeasy
import SwipeMenuViewController

class ProfileViewController: UIViewController {
    var presenter: ProfilePresenter!
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        return scroll
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var headerView: ProfileHeaderView = {
        let header = ProfileHeaderView()
        return header
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl()
        control.selectedSegmentTintColor = .viviRose50
        control.addTarget(self, action: #selector(pageDidChanged), for: .valueChanged)
        return control
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var menuView: ProfileMenuView = {
        let view = ProfileMenuView()
        view.isHidden = true
        return view
    }()
    
    private lazy var personalInfoView: PersonalInfoView = {
        let view = PersonalInfoView()
        view.isHidden = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupConstraints()
        setupNavigationBar()
        
        presenter.viewDidLoad()
    }
    
    func setupNavigationBar() {
        let logoutButton = UIBarButtonItem(title: "Выйти",
                                           style: .plain,
                                           target: self,
                                           action: #selector(logoutPressed))
        navigationItem.rightBarButtonItem = logoutButton
        navigationBarWithLogo()
        navigationItem.titleView?.easy.layout(CenterX())

    }
    
    func setupView() {
        view.backgroundColor = .background

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(headerView)
        contentView.addSubview(segmentedControl)
        contentView.addSubview(containerView)
        
        containerView.addSubview(menuView)
        containerView.addSubview(personalInfoView)
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
            Height().like(scrollView, .height)
        )
        
        headerView.easy.layout(
            Top(24),
            CenterX(),
            Leading(),
            Trailing()
        )
        
        segmentedControl.easy.layout(
            Top(24).to(headerView, .bottom),
            Leading(24),
            Trailing(24)
        )
        
        containerView.easy.layout(
            Top().to(segmentedControl, .bottom),
            Leading(),
            Trailing(),
            Bottom()
        )
        
        menuView.easy.layout(
            Top(16),
            Leading(),
            Trailing(),
            Bottom()
        )
        
        personalInfoView.easy.layout(
            Top(16),
            Leading(),
            Trailing(),
            Bottom()
        )
    }
}

extension ProfileViewController {
    @objc func logoutPressed() {
        presenter.logout()
    }
    
    @objc func pageDidChanged() {
        let index = segmentedControl.selectedSegmentIndex
        presenter.pageDidChange(index: index)
    }
}

extension ProfileViewController: ProfileViewType {
    func setupPages(pages: [PageType]) {
        pages.forEach {
            segmentedControl.insertSegment(withTitle: $0.rawValue, at: 0, animated: false)
        }
        segmentedControl.selectedSegmentIndex = 0
        pageDidChanged()
    }
    
    func setupPersonalInfo(info: [PersonalInfoViewModel]) {
        let newInfo = info.map {
            $0.type
        }
        personalInfoView.setupFields(fields: newInfo)
    }
    
    func changePage(to page: PageType) {
        switch page {
        case .project:
            menuView.isHidden = false
            personalInfoView.isHidden = true
        case .profile:
            menuView.isHidden = true
            personalInfoView.isHidden = false
        }
    }
    
    func navigation() -> UINavigationController? {
        return navigationController
    }
    
    func setupMenu(items: [ProfileMenuType]) {
        menuView.updateMenu(menuItems: items)
    }
    
    func updateUserInfo(user: UserModel) {
        headerView.update(user: user)
    }
}


