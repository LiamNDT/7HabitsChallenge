//
//  RoleTableViewController.swift
//  7HabitsChallenge
//
//  Created by Bui V Chanh on 07/08/2021.
//

import UIKit

class RoleTableViewController: UITableViewController {
    let reuseIdentifier = "RoleTableViewCell"
    
    typealias VM = RoleViewModel
    lazy var viewModel = RoleViewModel()
    
    var dataSource: RoleTableViewDiffableDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureDataSource()
        configureBinding()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { 0 }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? { nil }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        guard let roleSnapshot = dataSource.itemIdentifier(for: indexPath),
              let role = viewModel.listOfRole.first(where: { $0.id == roleSnapshot.id }) else { return }
        let alert = UIAlertController(title: "Vai trò: \(role.name)", message: role.content, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Đóng", style: .cancel))
        navigationController?.present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let roleSnapshot = dataSource.itemIdentifier(for: indexPath),
              let role = viewModel.listOfRole.first(where: { $0.id == roleSnapshot.id }) else { return }
        // Modify: check logic: in blacklist?
        //if not in {
        let detailModel = RoleDetailViewModel(role: role, action: .view, editAction: { [unowned self] edited in
            viewModel.update(item: edited)
            navigationController?.popViewController(animated: true)
        })
        let detailVC = RoleDetailViewController(viewModel: detailModel, style: .grouped)
        navigationController?.pushViewController(detailVC, animated: true)
        //} else{alrt}
    }
    
    @objc func addRole(_ sender: UIBarButtonItem) {
        let detailModel = RoleDetailViewModel(role: RoleViewModel.Item(), action: .new, addAction: { [unowned self] newRole in
            viewModel.save(item: newRole)
            dismiss(animated: true, completion: nil)
        })
        let detailVC = RoleDetailViewController(viewModel: detailModel, style: .grouped)
        let nav = UINavigationController(rootViewController: detailVC)
        navigationController?.present(nav, animated: true, completion: nil)
    }
    
    @available(iOS 11.0, *)
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Xoá") { [unowned self] _, _, complete in
            if let delete = dataSource.itemIdentifier(for: indexPath) {
                let actionSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                let cancelAction = UIAlertAction(title: "Huỷ", style: .cancel) { _ -> Void in }
                let deleteAction = UIAlertAction(title: "Xoá", style: .destructive) { _ -> Void in
                    viewModel.delete(item: delete)
                }

                actionSheetController.addAction(deleteAction)
                actionSheetController.addAction(cancelAction)
                present(actionSheetController, animated: true) {
                    complete(true)
                }
            }

            complete(false)
        }

        deleteAction.image = UIImage(systemName: "trash.fill")
        deleteAction.backgroundColor = .red

        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }

    class RoleTableViewDiffableDataSource: UITableViewDiffableDataSource<VM.Section, VM.Item> {
        override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            true
        }
    }
}

extension RoleTableViewController: ScreenConfiguration {
    func configureNavigationBar() {
        navigationItem.title = "Vai trò"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus.circle"), style: .plain, target: self, action: #selector(addRole))
    }
    
    func configureDataSource() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        dataSource = RoleTableViewDiffableDataSource(tableView: tableView, cellProvider: { [unowned self] tableView, indexPath, role in
            guard let roleModel = viewModel.listOfRole.first(where: { $0.id == role.id }) else { return nil }
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
            var content = cell.defaultContentConfiguration()
            content.text = roleModel.name

            let configure = UIImage.SymbolConfiguration(pointSize: 16)
            content.image = UIImage(systemName: roleModel.icon, withConfiguration: configure)
            content.imageProperties.tintColor = AppColor.primary
            
            cell.tintColor = AppColor.primary
            cell.accessoryType = .detailDisclosureButton
            cell.contentConfiguration = content
            
            return cell
        })
    }
    
    func configureBinding() {
        viewModel.binding = { [unowned self] items, action in
            var snapshot = dataSource.snapshot()
            if snapshot.sectionIdentifiers.isEmpty {
                snapshot.appendSections([.main])
            }
            if action == .add {
                snapshot.appendItems(items, toSection: .main)
            }
            
            if action == .remove {
                snapshot.deleteItems(items)
            }
            
            if action == .update {
                snapshot.reloadItems(items)
            }
            
            DispatchQueue.main.async {
                dataSource.apply(snapshot, animatingDifferences: true)
            }
        }
        viewModel.fetch()
    }
}
