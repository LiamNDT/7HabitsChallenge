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
    var dataSource: ManifestoTableViewDiffableDataSource!

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
        viewModel.binding = { [unowned self] items, event in
            var snapshot = dataSource.snapshot()
            if snapshot.numberOfSections == 0 {
                snapshot.appendSections([.main])
            }
            if event == .add {
                snapshot.appendItems(items)

            } else if event == .remove {
                snapshot.deleteItems(items)

            } else if event == .update {
                snapshot.reloadItems(items)
            }

            DispatchQueue.main.async {
                dataSource.apply(snapshot, animatingDifferences: true)
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
        dataSource = ManifestoTableViewDiffableDataSource(tableView: tableView, cellProvider: { [unowned self] tableView, indexPath, item in
            guard let storeItem = viewModel.listOfManifesto.filter({ $0.id == item.id }).first else { return nil }
            let cell = tableView.dequeueReusableCell(withIdentifier: defaultCellReuseIdentifier, for: indexPath)
            var content = cell.defaultContentConfiguration()
            content.text = storeItem.content
            content.secondaryText = storeItem.aspects.map { $0.title }.joined(separator: " - ")

            cell.contentConfiguration = content
            return cell
        })
        var snapshot = NSDiffableDataSourceSnapshot<VieWModel.Section, VieWModel.ManifestoItem>()
        snapshot.appendSections([.main])
        DispatchQueue.main.async { [unowned self] in
            dataSource.apply(snapshot, animatingDifferences: true)
        }
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { 0 }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? { nil }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let manifesto = dataSource.itemIdentifier(for: indexPath),
           let storeItem = viewModel.listOfManifesto.filter({ $0.id == manifesto.id }).first
        {
            let detailViewModel = ManifestoDetailViewModel(with: storeItem, action: .view, editAction: { [unowned self] updateManifesto in
                viewModel.update(item: updateManifesto)
                navigationController?.popViewController(animated: true)
            })
            let detailVC = ManifestoDetailViewController(style: .grouped, viewModel: detailViewModel)
            navigationController?.pushViewController(detailVC, animated: true)
        }
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

    class ManifestoTableViewDiffableDataSource: UITableViewDiffableDataSource<VieWModel.Section, VieWModel.ManifestoItem> {
        override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            true
        }
    }
}

extension ManifestoTableViewController {
    @objc func goToCreate(_ sender: UIBarButtonItem) {
        let empty = ManifestoViewModel.ManifestoItem(id: UUID(), content: "", aspects: [])
        let detailViewModel = ManifestoDetailViewModel(with: empty, action: .new, addAction: { [unowned self] newManifesto in
            viewModel.save(item: newManifesto)
            dismiss(animated: true, completion: nil)
        })
        let detailVC = ManifestoDetailViewController(style: .grouped, viewModel: detailViewModel)
        let nav = UINavigationController(rootViewController: detailVC)
        navigationController?.present(nav, animated: true, completion: nil)
    }
}
