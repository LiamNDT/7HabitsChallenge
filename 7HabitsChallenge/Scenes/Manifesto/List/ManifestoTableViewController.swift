//
//  ManifestoTableViewController.swift
//  7HabitsChallenge
//
//  Created by Bui V Chanh on 05/08/2021.
//

import UIKit

class ManifestoTableViewController: UITableViewController {
    typealias VieWModel = ManifestoViewModel
    let defaultCellReuseIdentifier = "ManifestoTableViewCell"

    var viewModel: ManifestoViewModel!
    var dataSource: UITableViewDiffableDataSource<VieWModel.Section, VieWModel.ManifestoItem>!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTitle(title: "Tuyên ngôn", largeMode: false, hasSearchBar: false)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: defaultCellReuseIdentifier)
        configureNavigationBar()
        configureDataSource()
        configureBinding()
    }

    private func configureBinding() {
        viewModel = ManifestoViewModel()
        viewModel.binding = { [unowned self] in
            if let list = viewModel.listOfManifesto {
                var snapshot = dataSource.snapshot()
                if snapshot.numberOfSections == 0 {
                    snapshot.appendSections([.main])
                }
                snapshot.deleteItems(snapshot.itemIdentifiers.filter { !list.contains($0) })
                snapshot.appendItems(list.filter { !snapshot.itemIdentifiers.contains($0) })
                DispatchQueue.main.async {
                    dataSource.apply(snapshot, animatingDifferences: true)
                }
            }
        }
        viewModel.fetch()
    }

    private func configureNavigationBar() {
        navigationController?.navigationBar.tintColor = AppColor.primary
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "pencil.and.outline"),
                                                            style: .plain, target: self, action: #selector(goToCreate))
    }

    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { [unowned self] tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: defaultCellReuseIdentifier, for: indexPath)
            var content = cell.defaultContentConfiguration()
            content.text = item.content

            cell.contentConfiguration = content
            return cell
        })
    }
}

extension ManifestoTableViewController {
    @objc func goToCreate(_ sender: UIBarButtonItem) {
        let empty = ManifestoViewModel.ManifestoItem(id: UUID(), content: "", aspects: [])
        let detailViewModel = ManifestoDetailViewModel(with: empty, action: .new) { [unowned self] newManifesto in
            viewModel.save(item: newManifesto)
            dismiss(animated: true, completion: nil)
        }
        let detailVC = ManifestoDetailViewController(style: .grouped, viewModel: detailViewModel)
        let nav = UINavigationController(rootViewController: detailVC)
        navigationController?.present(nav, animated: true, completion: nil)
    }
}
