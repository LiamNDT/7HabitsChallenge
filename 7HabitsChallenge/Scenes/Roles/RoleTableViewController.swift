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
    
    var dataSource: UITableViewDiffableDataSource<VM.Section, VM.Item>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureDataSource()
        configureBinding()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension RoleTableViewController: ScreenConfiguration {
    func configureNavigationBar() {
        navigationItem.title = "Vai trò"
    }
    
    func configureDataSource() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { [unowned self] tableView, indexPath, role in
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
            var content = cell.defaultContentConfiguration()
            content.text = role.name
            let configure = UIImage.SymbolConfiguration(pointSize: 16)
            content.image = UIImage(systemName: role.icon, withConfiguration: configure)
            content.imageProperties.tintColor = AppColor.primary
            
            cell.tintColor = AppColor.secondary
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
