//
//  DefinitionDetailViewController.swift
//  7HabitsChallenge
//
//  Created by Bui V Chanh on 03/08/2021.
//

import UIKit

class DefinitionDetailViewController: UITableViewController {
    typealias DefinitionChangeAction = (Definition) -> Void

    private var isNew = false
    private var definition: Definition?

    private var dataSource: DefinitionDetailViewDataSource!
    var definitionAddAction: DefinitionChangeAction?
    var definitionEditAction: DefinitionChangeAction?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.background
        navigationItem.setRightBarButton(editButtonItem, animated: false)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: DefinitionDetailViewDataSource.DefinitionSection.aspects.cellIdentifier())
        tableView.register(TextFieldCell.self, forCellReuseIdentifier: DefinitionDetailViewDataSource.DefinitionSection.content.cellIdentifier())
        tableView.allowsSelectionDuringEditing = true
        tableView.contentInsetAdjustmentBehavior = isNew ? .never : .automatic
        setEditing(isNew, animated: false)
    }

    func configure(with definition: Definition, isNew: Bool = false, addAction: DefinitionChangeAction? = nil, editAction: DefinitionChangeAction? = nil) {
        self.isNew = isNew
        self.definition = definition
        definitionAddAction = addAction
        definitionEditAction = editAction

        if isViewLoaded {
            setEditing(isNew, animated: true)
        }
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        guard let definition = definition else {
            fatalError("No definition found for detail view")
        }

        if dataSource == nil {
            dataSource = DefinitionDetailViewDataSource(definition: definition, tableview: tableView)
        }

        if editing {
            transitionToEditMode(definition: definition)
        } else {
            transitionToViewMode(definition: definition)
        }
    }

    private func transitionToViewMode(definition: Definition) {
        if isNew {
            // view.endEditing(true)
            dismiss(animated: true) {
                self.definitionAddAction?(definition)
            }
            return
        }

        definitionEditAction?(definition)

        navigationItem.title = "Tuyên ngôn"
        navigationItem.leftBarButtonItem = nil
        editButtonItem.isEnabled = true

        var snapshot = NSDiffableDataSourceSnapshot<DefinitionDetailViewDataSource.DefinitionSection, LifeThings.Aspect>()
        snapshot.appendSections([.content, .aspects])
        snapshot.appendItems([.none], toSection: .content)
        snapshot.appendItems(definition.aspects.sorted(by: { $0.rawValue < $1.rawValue }), toSection: .aspects)

        dataSource.apply(snapshot, animatingDifferences: true)
    }

    private func transitionToEditMode(definition: Definition) {
        navigationItem.title = isNew ? "Thêm Mới" : "Tuyên ngôn"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTrigger))

        var snapshot = NSDiffableDataSourceSnapshot<DefinitionDetailViewDataSource.DefinitionSection, LifeThings.Aspect>()
        snapshot.appendSections([.content, .aspects])
        snapshot.appendItems([.noneEdit], toSection: .content)
        snapshot.appendItems(LifeThings.Aspect.allCases.filter { $0 != .none && $0 != .noneEdit }, toSection: .aspects)

        dataSource.apply(snapshot, animatingDifferences: true)
    }

    @objc
    func cancelButtonTrigger(_ sender: UIBarButtonItem) {
        if isNew {
            dismiss(animated: true, completion: nil)
        } else {
            setEditing(false, animated: true)
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let definition = definition, let aspect = dataSource.itemIdentifier(for: indexPath), aspect != .none, aspect != .noneEdit, tableView.isEditing {
            var snapshot = dataSource.snapshot()
            if definition.aspects.contains(aspect) {
                definition.aspects.removeAll { $0 == aspect }
            } else {
                definition.aspects.append(aspect)
            }
            snapshot.reloadItems([aspect])
            dataSource.apply(snapshot, animatingDifferences: true)
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        if let aspect = dataSource.itemIdentifier(for: indexPath) {
            navigationController?.pushViewController(LifeAspectToValuesTableVC(aspect: aspect), animated: true)
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 && tableView.isEditing ? 120 : tableView.rowHeight
    }

    deinit {
        print("no leak on DefinitionDetailViewController")
    }
}
