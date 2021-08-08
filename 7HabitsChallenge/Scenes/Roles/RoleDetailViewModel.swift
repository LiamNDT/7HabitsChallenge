//
//  RoleDetailViewModel.swift
//  7HabitsChallenge
//
//  Created by Bui V Chanh on 08/08/2021.
//

import Foundation

class RoleDetailViewModel {
    enum Section: Int, CaseIterable {
        case name, label, content, icon
        var display: String {
            switch self {
            case .name: return "Vai trò"
            case .label: return "Gán nhãn"
            case .content: return "Nội dung"
            case .icon: return "Biểu tượng"
            }
        }

        var explain: String {
            switch self {
            case .content: return "Mô tả ngắn gọn về mục đích, ý nghĩa mà vai trò đem lại trong cuộc sống, định hình giá trị con người bạn!"
            default: return ""
            }
        }

        var cellReuseIdentifier: String {
            switch self {
            case .name, .label: return "roleTextFieldCell"
            case .content: return "roleTextViewCell"
            case .icon: return "roleTableViewCell"
            }
        }
    }

    struct Item: Hashable {
        static func == (lhs: Item, rhs: Item) -> Bool {
            lhs.id == rhs.id
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }

        let id = UUID()
        var value: String
        var type: Section
    }

    enum Action {
        case new, view, edit
    }

    typealias BindingToView = () -> ()
    var editModeBinding: BindingToView?

    typealias ChangeAction = (RoleViewModel.Item) -> ()
    var addAction: ChangeAction?
    var editAction: ChangeAction?

    var fields: [Item]
    var role: RoleViewModel.Item
    var repository: RoleRepository
    var action: Action

    init(role: RoleViewModel.Item, action: Action, addAction: ChangeAction? = nil, editAction: ChangeAction? = nil) {
        fields = [
            Item(value: role.name, type: .name),
            Item(value: role.code, type: .label),
            Item(value: role.icon, type: .icon),
            Item(value: role.content, type: .content),
        ]
        repository = RoleRepository()
        self.action = action
        self.role = role
        self.addAction = addAction
        self.editAction = editAction
    }

    func saveOrRestore() {
        if action == .new, let addAction = addAction {
            addAction(role)

        } else if action == .edit, let editAction = editAction {
            editAction(role)
        }
    }

    func enabledEditMode() {
        action = .edit
        editModeBinding?()
    }

    func disabledEditMode() {
        action = .view
        editModeBinding?()
    }
}
