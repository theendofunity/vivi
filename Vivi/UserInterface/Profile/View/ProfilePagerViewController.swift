//
//  ProfilePagerViewController.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 12.05.2022.
//

import UIKit
import EasyPeasy

class ProfilePagerViewController: UIViewController {
    var presenter: ProfilePagerPresenter!
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        return scroll
    }()
    
    private lazy var headerView: ProfileHeaderView = {
        let header = ProfileHeaderView()
        return header
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Профиль", "Проект"])
        control.selectedSegmentTintColor = .viviRose50
        control.selectedSegmentIndex = 0
        return control
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupView()
        setupConstraints()
        navigationBarWithLogo()
    }
    
    func setupView() {
        view.backgroundColor = .background

        view.addSubview(scrollView)
        
        scrollView.addSubview(headerView)
        scrollView.addSubview(segmentedControl)
        scrollView.addSubview(containerView)
    }
    
    func setupConstraints() {
        scrollView.easy.layout(
            Top().to(view.safeAreaLayoutGuide, .top),
            Leading(),
            Trailing(),
            Bottom().to(view.safeAreaLayoutGuide, .bottom)
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
            Top(16).to(segmentedControl, .bottom),
            Leading(),
            Trailing(),
            Bottom()
        )
    }
}

extension ProfilePagerViewController: ProfilePagerViewType {
    
}
