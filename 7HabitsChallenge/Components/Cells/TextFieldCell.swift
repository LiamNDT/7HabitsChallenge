//
//  TextFieldCell.swift
//  7HabitsChallenge
//
//  Created by Bui V Chanh on 03/08/2021.
//

import UIKit

class TextFieldCell: UITableViewCell {
    static let reuseIdentifier = "TextFieldCell"

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

//    func configure(content: String, changedAction: @escaping ContentChangedAction) {
//        textField.text = content
//        self.changedAction = changedAction
//    }

    lazy var icon = UIImageView(image: nil)
    lazy var textField = UITextField(frame: .zero)
}

extension TextFieldCell {
    private func setupViews() {
        icon.tintColor = AppColor.secondary
        textField.delegate = self

        [icon, textField].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            icon.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            icon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            icon.heightAnchor.constraint(equalToConstant: 30),
            icon.widthAnchor.constraint(equalToConstant: 30),

            textField.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            textField.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 10),
            textField.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
            textField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}

extension TextFieldCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let originalText = textField.text {
            let content = (originalText as NSString).replacingCharacters(in: range, with: string)
            changedAction?(content)
        }
        return true
    }
}
