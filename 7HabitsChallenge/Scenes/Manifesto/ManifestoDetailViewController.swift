//
//  ManifestoDetailViewController.swift
//  7HabitsChallenge
//
//  Created by Bui V Chanh on 05/08/2021.
//

import UIKit

class ManifestoDetailViewController: UITableViewController {
    typealias ViewModel = ManifestoDetailViewModel

    let defaultCellReuseIdentifier = "ManifestoDefaultCell"
    let defaultHeaderReuseIdentifier = "ManifestoDefaultHeader"

    var dataSource: UITableViewDiffableDataSource<ViewModel.Section, ViewModel.Field>!
    var viewModel: ManifestoDetailViewModel

    init(style: UITableView.Style, viewModel: ManifestoDetailViewModel) {
        self.viewModel = viewModel
        super.init(style: style)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: defaultCellReuseIdentifier)
        tableView.register(TextViewCell.self, forCellReuseIdentifier: TextViewCell.reuseIdentifier)
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: defaultHeaderReuseIdentifier)
        tableView.keyboardDismissMode = .onDrag
        configureNavigationBar()
        configureDataSource()
        configureBinding()
    }

    private func configureBinding() {
        viewModel.bindingFields = { [unowned self] field in
            var snapshot = dataSource.snapshot()
            snapshot.reloadItems([field])
            DispatchQueue.main.async { [unowned self] in
                dataSource.apply(snapshot, animatingDifferences: true)
            }
        }

        viewModel.editModeBinding = { [unowned self] in
            configureNavigationBar()

            var snapshot = dataSource.snapshot()

            if viewModel.action == .edit {
                let onlyAspect = snapshot.itemIdentifiers(inSection: .aspects).map { $0.aspect }
                let newFields = LifeThings.Aspect.allCases.filter { $0 != .none && !onlyAspect.contains($0) }
                    .map { ViewModel.Field(content: "", aspect: $0) }
                snapshot.appendItems(newFields, toSection: .aspects)
                snapshot.reloadSections([.content, .aspects])

            } else if viewModel.action == .view {
                snapshot.deleteItems(snapshot.itemIdentifiers.filter { $0.aspect != nil && !viewModel.listOfAspect.contains($0.aspect!) })
                snapshot.reloadSections([.content, .aspects])
            }

            DispatchQueue.main.async { [unowned self] in
                dataSource.apply(snapshot, animatingDifferences: true)
            }
        }
    }

    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { [unowned self] tableView, indexPath, field in
            if field.aspect == nil && (viewModel.action == .new || viewModel.action == .edit) {
                let cell = tableView.dequeueReusableCell(withIdentifier: TextViewCell.reuseIdentifier, for: indexPath) as! TextViewCell
                cell.textField.text = viewModel.content
                cell.textField.isUserInteractionEnabled = true
                cell.changedAction = { viewModel.content = $0 }
                cell.tintColor = AppColor.secondary
                return cell
            }

            if field.aspect != nil || (field.aspect == nil && viewModel.action == .view) {
                let cell = tableView.dequeueReusableCell(withIdentifier: defaultCellReuseIdentifier, for: indexPath)
                var content = cell.defaultContentConfiguration()
                content.text = field.content
                if field.aspect != nil {
                    content.text = field.aspect?.title
                    content.image = UIImage(systemName: viewModel.listOfAspect.contains(field.aspect!) ? "checkmark.circle.fill" : "circle")
                    content.imageProperties.tintColor = viewModel.listOfAspect.contains(field.aspect!) ? AppColor.primary : AppColor.secondary
                    cell.accessoryType = .detailButton
                }

                cell.tintColor = AppColor.secondary
                cell.contentConfiguration = content
                return cell
            }

            return nil
        })

        var snapshot = NSDiffableDataSourceSnapshot<ViewModel.Section, ViewModel.Field>()
        snapshot.appendSections([.content, .aspects])
        snapshot.appendItems([ViewModel.Field(content: viewModel.content, aspect: nil)], toSection: .content)

        if viewModel.action == .new || viewModel.action == .edit {
            snapshot.appendItems(LifeThings.Aspect.allCases.filter { $0 != .none }.map { ViewModel.Field(content: "", aspect: $0) }, toSection: .aspects)

        } else if viewModel.action == .view {
            snapshot.appendItems(viewModel.listOfAspect.map { ViewModel.Field(content: "", aspect: $0) }, toSection: .aspects)
        }

        DispatchQueue.main.async { [unowned self] in
            dataSource.apply(snapshot, animatingDifferences: true)
        }
    }

    private func configureNavigationBar() {
        if viewModel.action == .new {
            navigationItem.title = "Thêm mới"
            navigationItem.leftBarButtonItem = cancelButton
            navigationItem.rightBarButtonItem = doneButton

        } else if viewModel.action == .view {
            navigationItem.title = "Chi tiết"
            navigationItem.leftBarButtonItem = nil
            navigationItem.rightBarButtonItem = editlButton

        } else if viewModel.action == .edit {
            navigationItem.title = "Chỉnh sửa"
            navigationItem.leftBarButtonItem = cancelButton
            navigationItem.rightBarButtonItem = doneButton
        }
        navigationController?.navigationBar.tintColor = AppColor.primary
    }

    lazy var cancelButton = UIBarButtonItem(title: "Huỷ", style: .plain, target: self, action: #selector(cancelAction))
    lazy var doneButton = UIBarButtonItem(title: "Xong", style: .plain, target: self, action: #selector(doneAction))
    lazy var editlButton = UIBarButtonItem(title: "Sửa", style: .plain, target: self, action: #selector(editAction))
}

extension ManifestoDetailViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let section = ViewModel.Section(rawValue: indexPath.section), section == .content, viewModel.action != .view {
            return 120
        }
        return tableView.rowHeight
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: defaultHeaderReuseIdentifier)
        header?.textLabel?.text = ViewModel.Section(rawValue: section)?.label.uppercased()
        return header
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let field = dataSource.itemIdentifier(for: indexPath), viewModel.action != .view {
            if field.aspect != nil {
                viewModel.onSelectField(field)
                view.endEditing(true)
            } else {
                if let cell = tableView.cellForRow(at: indexPath) as? TextViewCell, !cell.textField.isFirstResponder {
                    cell.textField.becomeFirstResponder()
                }
            }
        }
    }

    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        if let field = dataSource.itemIdentifier(for: indexPath), field.aspect != nil {
            navigationController?.pushViewController(LifeAspectToValuesTableVC(aspect: field.aspect!), animated: true)
        }
    }
}

extension ManifestoDetailViewController {
    @objc func cancelAction(_ sender: UIBarButtonItem) {
        if viewModel.action == .new {
            dismiss(animated: true, completion: nil)

        } else if viewModel.action == .edit {
            viewModel.disabledEditMode()
        }
    }

    @objc func doneAction(_ sender: UIBarButtonItem) {
        viewModel.saveOrRestore()
    }

    @objc func editAction(_ sender: UIBarButtonItem) {
        viewModel.enabledEditMode()
    }
}
