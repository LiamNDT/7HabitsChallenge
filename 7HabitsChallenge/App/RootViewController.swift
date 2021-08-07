//
//  AppEntryViewController.swift
//  7HabitsChallenge
//
//  Created by Bui V Chanh on 03/08/2021.
//

import UIKit

class RootViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabs()
        view.backgroundColor = AppColor.background
        selectedIndex = 2
    }

    private func configureTabs() {
        let tab0 = UINavigationController(rootViewController: UIViewController())
        tab0.tabBarItem = UITabBarItem(title: "Trang chủ", image: UIImage(systemName: "house"), tag: 0)

        let tab1 = UINavigationController(rootViewController: UIViewController())
        tab1.tabBarItem = UITabBarItem(title: "Kế hoạch", image: UIImage(systemName: "calendar"), tag: 1)

        let tab2 = UINavigationController(rootViewController: ProfileTableViewController(style: .grouped))
        tab2.tabBarItem = UITabBarItem(title: "Hồ sơ", image: UIImage(systemName: "person.crop.circle"), tag: 2)

        viewControllers = [tab0, tab1, tab2]
        tabBar.backgroundColor = AppColor.background
        tabBar.barTintColor = AppColor.background
        tabBar.tintColor = AppColor.primary
    }
}
