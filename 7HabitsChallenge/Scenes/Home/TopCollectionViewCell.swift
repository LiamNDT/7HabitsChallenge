//
//  TopCollectionViewCell.swift
//  7HabitsChallenge
//
//  Created by Bui V Chanh on 07/08/2021.
//

import UIKit

class TopCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "top-slide-cell-reuseidentifier"

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let titleLabel = UILabel()
    // TODO: image
}

extension TopCollectionViewCell {
    func configure() {
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.numberOfLines = 10
        titleLabel.lineBreakMode = .byWordWrapping
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            titleLabel.heightAnchor.constraint(equalToConstant: 70)
        ])
        makeBorderRadius(16)
        layer.borderColor = AppColor.secondary.cgColor
        layer.borderWidth = 1
        backgroundColor = AppColor.white
    }
}
