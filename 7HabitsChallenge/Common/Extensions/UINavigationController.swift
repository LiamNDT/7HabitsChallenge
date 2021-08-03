//
//  AppNavigationController.swift
//  ECATALOGUE
//
//  Created by Bui V Chanh on 27/07/2021.
//

import UIKit

final class AppNavigationController: UINavigationController {
    override public var childForStatusBarStyle: UIViewController? {
        return visibleViewController
    }

    override public var preferredStatusBarStyle: UIStatusBarStyle {
        return visibleViewController?.preferredStatusBarStyle ?? .lightContent
    }
}
