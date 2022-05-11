//
//  ProfilePagerViewController.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 12.05.2022.
//

import UIKit
import EasyPeasy

class ProfilePagerViewController: UIPageViewController {

    var orderedViewControllers: [UIViewController] = []
    
    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let vc1 = ProfileViewController()
        let presenter1 = ProfilePresenter()
        vc1.presenter = presenter1
        presenter1.view = vc1
        let vc2 = ProfileViewController()
        let presenter2 = ProfilePresenter()
        vc2.presenter = presenter2
        presenter2.view = vc2
        orderedViewControllers = [vc1, vc2]
//        options.tabView.backgroundColor = .viviRose50 ?? .blue
        setViewControllers([vc1], direction: .forward, animated: true)
        dataSource = self
        delegate = self
        
        navigationBarWithLogo()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
   
}

extension ProfilePagerViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
                   return nil
               }
               
               let previousIndex = viewControllerIndex - 1
               
               guard previousIndex >= 0 else {
                   return nil
               }
               
               guard orderedViewControllers.count > previousIndex else {
                   return nil
               }
               
               return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController)else {
                    return nil
                }
                
                let nextIndex = viewControllerIndex + 1
                let orderedViewControllersCount = orderedViewControllers.count

                guard orderedViewControllersCount != nextIndex else {
                    return nil
                }
                
                guard orderedViewControllersCount > nextIndex else {
                    return nil
                }
                
                return orderedViewControllers[nextIndex]
    }
    
    
}
