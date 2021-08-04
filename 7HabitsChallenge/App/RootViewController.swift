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
        selectedIndex = 0
    }

    private func configureTabs() {
        let tab0 = UINavigationController(rootViewController: DefinitionListViewController(style: .grouped))
        tab0.tabBarItem = UITabBarItem(title: "Tuyên ngôn", image: UIImage(systemName: "list.bullet.rectangle"), tag: 2)

        viewControllers = [tab0]
        tabBar.backgroundColor = AppColor.background
        tabBar.barTintColor = AppColor.background
        tabBar.tintColor = AppColor.primary
    }
}
