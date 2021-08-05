//
//  TextViewCell.swift
//  7HabitsChallenge
//
//  Created by Bui V Chanh on 05/08/2021.
//

import UIKit

class TextViewCell: UITableViewCell {
    static let reuseIdentifier = "TextViewCell"

    typealias ContentChangedAction = (String) -> Void

    var changedAction: ContentChangedAction?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var textField = UITextView(frame: .zero)
}

extension TextViewCell {
    private func setupViews() {
        textField.delegate = self
        textField.font = .systemFont(ofSize: 16)
        [textField].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            textField.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

extension TextViewCell: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let originalText = textField.text {
            let content = (originalText as NSString).replacingCharacters(in: range, with: text)
            changedAction?(content)
        }
        return true
    }
}
