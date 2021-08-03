//
//  UITableView.swift
//  SevenHabitsChallenge
//
//  Created by Bui V Chanh on 02/08/2021.
//

import UIKit

extension UITableView {
    func setEmptyView(_ view: UIView) {
        self.backgroundView = view
        self.separatorStyle = .none
    }

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: self.bounds)
        messageLabel.text = message
        messageLabel.textColor = AppColor.primary
        messageLabel.numberOfLines = 5
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 20)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
