//
//  ProfilePagerViewController.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 12.05.2022.
//

import UIKit
import EasyPeasy

class ProfileViewController: UIViewController {
    var presenter: ProfilePresenter!
    
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
        let header = ProfileHeaderView(position: .center)
        header.delegate = self
        return header
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl()
        control.selectedSegmentTintColor = .viviRose50
        control.addTarget(self, action: #selector(pageDidChanged), for: .valueChanged)
        if let color = UIColor.denim {
            control.setTitleTextAttributes([.foregroundColor: color], for: .selected)
            control.setTitleTextAttributes([.foregroundColor: color], for: .normal)
        }

        return control
    }()
    
    private lazy var menuView: ProfileMenuView = {
        let view = ProfileMenuView()
        view.isHidden = true
        view.delegate = self
        return view
    }()
    
    private lazy var personalInfoView: PersonalInfoView = {
        let view = PersonalInfoView()
        view.isHidden = true
        view.delegate = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupConstraints()
        setupNavigationBar()
        setupNotifications()
        presenter.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationBarWithLogo()
        scrollView.setContentOffset(.zero, animated: false)
        presenter.viewDidAppear()
    }
    
    func setupNavigationBar() {
        let logoutButton = UIBarButtonItem(title: "Выйти",
                                           style: .plain,
                                           target: self,
                                           action: #selector(logoutPressed))
        navigationItem.rightBarButtonItem = logoutButton
        navigationBarWithLogo()
    }
    
    func setupView() {
        view.backgroundColor = .background

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(headerView)
        contentView.addSubview(segmentedControl)
        
        contentView.addSubview(menuView)
        contentView.addSubview(personalInfoView)
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
        
        segmentedControl.easy.layout(
            Top(24).to(headerView, .bottom),
            Leading(24),
            Trailing(24)
        )
        
        menuView.easy.layout(
            Top(16).to(segmentedControl, .bottom),
            Leading(),
            Trailing(),
            Bottom()
        )
        
        personalInfoView.easy.layout(
            Top(16).to(segmentedControl, .bottom),
            Leading(),
            Trailing(),
            Bottom(24)
        )
    }
    
    func setupNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
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
    func showSaveSuccess() {
        showAlert(title: "Успешно!", message: "Данные обновлены")
    }
    
    func showError(error: Error) {
        alertError(error: error)
    }
    
    func setupPages(pages: [PageType]) {
        segmentedControl.removeAllSegments()
        
        pages.forEach {
            let lastIndex = segmentedControl.numberOfSegments
            segmentedControl.insertSegment(withTitle: $0.rawValue, at: lastIndex, animated: false)
        }
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.isHidden = pages.count == 1
        
        pageDidChanged()
    }
    
    func setupPersonalInfo(info: [TextFieldViewModel]) {
        personalInfoView.setupFields(fields: info)
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
        headerView.update(data: user)
    }
}

extension ProfileViewController: ProfileMenuViewDelegate {
    func menuItemDidSelect(item: ProfileMenuType) {
        presenter.menuItemDidSelect(item: item)
    }
}

extension ProfileViewController: HeaderViewDelegate {
    func avatarDidSelect() {
        showImagePicker()
    }
    
    func showImagePicker() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.mediaTypes = ["public.image"]
        
        navigationController?.present(picker, animated: true)
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        presenter.setAvatar(image: image)
        dismiss(animated: true)
    }
}

extension ProfileViewController: PersonalInfoViewDelegate {
    func securityButtonPressed() {
        presenter.securityButtonPressed()
    }
    
    func saveButtonPressed(models: [TextFieldViewModel]) {
        presenter.saveButtonPressed(models: models)
    }
}

extension ProfileViewController {
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = .zero
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
}
