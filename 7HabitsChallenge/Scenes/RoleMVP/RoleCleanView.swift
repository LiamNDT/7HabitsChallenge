//
//  RoleCleanTableViewController.swift
//  7HabitsChallenge
//
//  Created by Bui V Chanh on 08/08/2021.
//

import UIKit

class RoleCleanDefaultView: UITableViewController {
    // MARK: - Vars&Lets

    let reuseIdentifier = "RoleCleanTableViewCell"
    var presenter: RoleCleanPresenter?
    var dataSource: RoleCleanDataSource!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureDataSource()
        presenter?.didLoad()
    }

    private func configureNavigationBar() {
        navigationItem.title = "Vai trò"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus.circle"), style: .plain, target: self, action: #selector(addRole))
    }

    private func configureDataSource() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)

        dataSource = RoleCleanDataSource(tableView: tableView, cellProvider: { [unowned self] tableView, indexPath, role in
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
            var content = cell.defaultContentConfiguration()
            content.text = role.name
            content.imageProperties.tintColor = AppColor.primary

            cell.tintColor = AppColor.primary
            cell.accessoryType = .detailDisclosureButton
            cell.contentConfiguration = content

            return cell
        })
    }

    @objc private func addRole(_ sender: UIBarButtonItem) {
        presenter?.didTapAddNew()
    }

    // MARK: - TableView Delegate

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { 0 }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? { nil }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let roleItem = dataSource.itemIdentifier(for: indexPath) else { return }
        presenter?.didSelectedRole(roleItem)
    }
}

extension RoleCleanDefaultView: RoleCleanView {
    func displayLoading() {
        // TODO:
    }

    func confirmDelete() {}

    func binding(_ items: [RoleCleanItem], event: RoleCleanBindingState) {
        event.handleRequest(items, dataSource: dataSource)
    }
}

// MARK: - Custom DataSource

class RoleCleanDataSource: UITableViewDiffableDataSource<RoleCleanSection, RoleCleanItem> {
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { true }
}

// MARK: Binding State

final class NewState: RoleCleanBindingState {
    func handleRequest(_ items: [RoleCleanItem], dataSource: RoleCleanDataSource) {
        var snapshot = dataSource.snapshot()
        if snapshot.sectionIdentifiers.isEmpty {
            snapshot.appendSections([.main])
        }
        snapshot.appendItems(items, toSection: .main)
        DispatchQueue.main.async {
            dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
}

final class UpdateState: RoleCleanBindingState {
    func handleRequest(_ items: [RoleCleanItem], dataSource: RoleCleanDataSource) {
        var snapshot = dataSource.snapshot()
        snapshot.reloadItems(items)
        DispatchQueue.main.async {
            dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
}

final class DeleteState: RoleCleanBindingState {
    func handleRequest(_ items: [RoleCleanItem], dataSource: RoleCleanDataSource) {
        var snapshot = dataSource.snapshot()
        snapshot.deleteItems(items)
        DispatchQueue.main.async {
            dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
}
