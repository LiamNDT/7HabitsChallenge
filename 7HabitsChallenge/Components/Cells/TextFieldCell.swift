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

    lazy var textField = UITextField(frame: .zero)
}

extension TextFieldCell {
    private func setupViews() {
        textField.delegate = self
        textField.font = .systemFont(ofSize: 16)
        [textField].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            textField.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            textField.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
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
