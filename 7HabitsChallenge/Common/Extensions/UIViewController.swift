//
//  UIViewController.swift
//  ECATALOGUE
//
//  Created by Bui V Chanh on 27/07/2021.
//

import UIKit

extension UIViewController {
    func configureTitle(title: String, largeMode: Bool, hasSearchBar: Bool) {
        navigationItem.title = title
        navigationItem.hidesSearchBarWhenScrolling = hasSearchBar
        navigationController?.navigationBar.prefersLargeTitles = largeMode
        navigationItem.largeTitleDisplayMode = .automatic
        view.backgroundColor = AppColor.background
    }

    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }

    func remove() {
        guard parent != nil else {
            return
        }

        willMove(toParent: nil)
        removeFromParent()
        view.removeFromSuperview()
    }

    // keyboard
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}
