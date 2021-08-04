//
//  DefinitionTableViewController.swift
//  7HabitsChallenge
//
//  Created by Bui V Chanh on 03/08/2021.
//

import UIKit

class DefinitionListViewController: UITableViewController {
    var dataSource: DefinitionListDataSource!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTitle(title: "Tuyên ngôn", largeMode: false, hasSearchBar: true)
        configureNavigationBar()
        configureDataSource()
    }

    private func configureNavigationBar() {
        navigationController?.navigationBar.tintColor = AppColor.primary
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "pencil.and.outline"),
                                                            style: .plain, target: self, action: #selector(goToCreate))
    }

    private func configureDataSource() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: DefinitionListDataSource.reuseIdentifier)
        dataSource = DefinitionListDataSource(tableView: tableView)
        dataSource.retrieve { [unowned self] list in
            var snapshot = NSDiffableDataSourceSnapshot<DefinitionListDataSource.Section, Definition>()
            snapshot.appendSections([.main])
            snapshot.appendItems(list, toSection: .main)
            dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let definition = dataSource.itemIdentifier(for: indexPath) else { return }
        let detailVC = DefinitionDetailViewController(style: .grouped)
        detailVC.configure(with: definition, isNew: false, editAction: { [unowned self] definition in
            dataSource.update(definition, completion: { definitionUpdated in
                if let updated = definitionUpdated {
                    DispatchQueue.main.async {
                        var snapshot = dataSource.snapshot()
                        snapshot.reloadItems([updated])
                        dataSource.apply(snapshot)
                    }
                }
            })
        })
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension DefinitionListViewController {
    @objc func goToCreate(_ sender: UIBarButtonItem) {
        let detailVC = DefinitionDetailViewController(style: .grouped)
        detailVC.configure(with: Definition(), isNew: true, addAction: { [unowned self] definition in
            dataSource.save(definition, completion: { definitionAdded in
                if let added = definitionAdded {
                    DispatchQueue.main.async {
                        var snapshot = dataSource.snapshot()
                        snapshot.appendItems([added], toSection: .main)
                        dataSource.apply(snapshot)
                    }
                }
            })
        })
        let nav = UINavigationController(rootViewController: detailVC)
        navigationController?.present(nav, animated: true, completion: nil)
    }
}
