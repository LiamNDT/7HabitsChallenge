//
//  DefinitionDetailViewController.swift
//  7HabitsChallenge
//
//  Created by Bui V Chanh on 03/08/2021.
//

import UIKit

class DefinitionDetailViewController: UITableViewController {
    private var isNew = false
    private var definition: Definition?
    private var tempDefinition: Definition?

    private var dataSource: DefinitionDetailEditDataSource!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.background
        navigationItem.setRightBarButton(editButtonItem, animated: false)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: DefinitionDetailEditDataSource.DefinitionSection.aspects.cellIdentifier())
        tableView.register(TextFieldCell.self, forCellReuseIdentifier: DefinitionDetailEditDataSource.DefinitionSection.content.cellIdentifier())
        tableView.allowsSelectionDuringEditing = true
        setEditing(isNew, animated: false)
    }

    func configure(with definition: Definition, isNew: Bool = false) {
        self.definition = definition
        self.isNew = isNew
        if isViewLoaded {
            setEditing(isNew, animated: true)
        }
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        guard let definition = definition else {
            fatalError("No definition found for detail view")
        }
        if editing {
            transitionToEditMode(definition: definition)
        } else {
            // transitionToViewMode(reminder)
            // tableView.backgroundColor = UIColor(named: "VIEW_Background")
        }
        // tableView.dataSource = dataSource
        // tableView.reloadData()
    }

    private func transitionToEditMode(definition: Definition) {
        navigationItem.title = isNew ? "Thêm Mới" : "Tuyên ngôn"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTrigger))

        var snapshot = NSDiffableDataSourceSnapshot<DefinitionDetailEditDataSource.DefinitionSection, LifeThings.Aspect>()
        snapshot.appendSections([.content, .aspects])
        snapshot.appendItems([.none], toSection: .content)
        snapshot.appendItems(LifeThings.Aspect.allCases.filter { $0 != .none }, toSection: .aspects)

        dataSource = DefinitionDetailEditDataSource(definition: definition, tableview: tableView)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    @objc
    func cancelButtonTrigger(_ sender: UIBarButtonItem) {
        if isNew {
            dismiss(animated: true, completion: nil)
        } else {
            tempDefinition = nil
            setEditing(false, animated: true)
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let definition = definition, let aspect = dataSource.itemIdentifier(for: indexPath), aspect != .none {
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

    deinit {
        print("no leak on DefinitionDetailViewController")
    }
}
