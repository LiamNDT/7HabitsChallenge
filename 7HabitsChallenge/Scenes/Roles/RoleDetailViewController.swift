//
//  RoleDetailViewController.swift
//  7HabitsChallenge
//
//  Created by Bui V Chanh on 08/08/2021.
//

import UIKit

class RoleDetailViewController: UITableViewController {
    let roleDefaultReuseIdentifier = "roleDefaultReuseIdentifier"
    let defaultHeaderReuseIdentifier = "RoleDefaultHeaderReuseIdentifier"

    typealias VM = RoleDetailViewModel
    var viewModel: RoleDetailViewModel!

    var dataSource: UITableViewDiffableDataSource<VM.Section, VM.Item>!

    init(viewModel: RoleDetailViewModel, style: UITableView.Style) {
        self.viewModel = viewModel
        super.init(style: style)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureDataSource()
        configureBinding()
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let section = VM.Section(rawValue: indexPath.section), viewModel.action != .view, section == .content {
            return 120
        }
        return tableView.rowHeight
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: defaultHeaderReuseIdentifier)
        header?.textLabel?.text = VM.Section(rawValue: section)?.display.uppercased()
        return header
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: defaultHeaderReuseIdentifier)
        footer?.textLabel?.text = VM.Section(rawValue: section)?.explain
        footer?.textLabel?.numberOfLines = 5
        footer?.textLabel?.lineBreakMode = .byWordWrapping
        return footer
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard viewModel.action != .view else { return }

        if let field = dataSource.itemIdentifier(for: indexPath) {
            if field.type != .icon, let cell = tableView.cellForRow(at: indexPath) as? TextViewCell, !cell.textField.isFirstResponder {
                cell.textField.becomeFirstResponder()
                return
            }

            if field.type != .icon, let cell = tableView.cellForRow(at: indexPath) as? TextFieldCell, !cell.textField.isFirstResponder {
                cell.textField.becomeFirstResponder()
                return
            }

            if field.type == .icon {
                // TODO: show icon list
                return
            }
        }
    }

    @objc func cancel(_ sender: UIBarButtonItem) {
        if viewModel.action == .new {
            dismiss(animated: true, completion: nil)

        } else if viewModel.action == .edit {
            viewModel.disabledEditMode()
        }
    }

    @objc func done(_ sender: UIBarButtonItem) {
        viewModel.saveOrRestore()
    }

    @objc func edit(_ sender: UIBarButtonItem) {
        viewModel.enabledEditMode()
    }
}

extension RoleDetailViewController: ScreenConfiguration {
    func configureNavigationBar() {
        let editButton = UIBarButtonItem(title: "Sửa", style: .plain, target: self, action: #selector(edit))
        let doneButton = UIBarButtonItem(title: "Xong", style: .done, target: self, action: #selector(done))
        let cancelButton = UIBarButtonItem(title: "Huỷ", style: .plain, target: self, action: #selector(cancel))

        if viewModel.action == .new {
            navigationItem.title = "Thêm mới"
            navigationItem.leftBarButtonItem = cancelButton
            navigationItem.rightBarButtonItem = doneButton

        } else if viewModel.action == .view {
            navigationItem.title = viewModel.role.name
            navigationItem.leftBarButtonItem = nil
            navigationItem.rightBarButtonItem = editButton

        } else if viewModel.action == .edit {
            navigationItem.title = "Chỉnh sửa"
            navigationItem.leftBarButtonItem = cancelButton
            navigationItem.rightBarButtonItem = doneButton
        }
        navigationController?.navigationBar.tintColor = AppColor.primary
    }

    func configureDataSource() {
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: defaultHeaderReuseIdentifier)
        tableView.register(TextFieldCell.self, forCellReuseIdentifier: VM.Section.name.cellReuseIdentifier)
        tableView.register(TextViewCell.self, forCellReuseIdentifier: VM.Section.content.cellReuseIdentifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: roleDefaultReuseIdentifier)
        tableView.keyboardDismissMode = .onDrag

        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { [unowned self] tableView, indexPath, item in
            guard let section = VM.Section(rawValue: indexPath.section) else { return nil }
            if viewModel.action == .view {
                let cell = tableView.dequeueReusableCell(withIdentifier: roleDefaultReuseIdentifier, for: indexPath)
                var content = cell.defaultContentConfiguration()
                content.text = item.value
                cell.contentConfiguration = content
                return cell

            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: section.cellReuseIdentifier, for: indexPath)
                if section == .name, let cell = cell as? TextFieldCell {
                    cell.textField.text = viewModel.role.name
                    cell.textField.placeholder = "Bạn đóng vai trò gì?"
                    cell.textField.isUserInteractionEnabled = true
                    cell.changedAction = { viewModel.role.name = $0 }
                    return cell
                }

                if section == .label, let cell = cell as? TextFieldCell {
                    cell.textField.text = viewModel.role.code
                    cell.textField.placeholder = "Gán nhãn để dễ phân loại, tìm kiếm"
                    cell.textField.isUserInteractionEnabled = true
                    cell.changedAction = { viewModel.role.code = $0 }
                    return cell
                }

                if section == .content, let cell = cell as? TextViewCell {
                    cell.textField.text = viewModel.role.content
                    cell.textField.isUserInteractionEnabled = true
                    cell.changedAction = { viewModel.role.content = $0 }
                    return cell
                }
            }

            return nil
        })

        var snapshot = NSDiffableDataSourceSnapshot<VM.Section, VM.Item>()
        snapshot.appendSections([.name, .label, .content])
        snapshot.appendItems(viewModel.fields.filter { $0.type == .name }, toSection: .name)
        snapshot.appendItems(viewModel.fields.filter { $0.type == .label }, toSection: .label)
        snapshot.appendItems(viewModel.fields.filter { $0.type == .content }, toSection: .content)

        DispatchQueue.main.async { [unowned self] in
            dataSource.apply(snapshot, animatingDifferences: true)
        }
    }

    func configureBinding() {
        viewModel.editModeBinding = { [unowned self] in
            configureNavigationBar()

            var snapshot = dataSource.snapshot()
            snapshot.reloadItems(snapshot.itemIdentifiers)

            DispatchQueue.main.async { [unowned self] in
                dataSource.apply(snapshot, animatingDifferences: true)
            }
        }
    }
}
