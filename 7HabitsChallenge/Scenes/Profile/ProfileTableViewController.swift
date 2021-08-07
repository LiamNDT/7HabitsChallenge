//
//  ProfileTableViewController.swift
//  7HabitsChallenge
//
//  Created by Bui V Chanh on 07/08/2021.
//

import UIKit

class ProfileTableViewController: UITableViewController {
    let cellReuseIdentifier = "ProfileTableCellReuseIdentifier"
    let headerReuseIdentifier = "ProfileTableHeaderReuseIdentifier"

    typealias VM = ProfileViewModel
    lazy var viewModel = ProfileViewModel()

    var dataSource: UITableViewDiffableDataSource<VM.Section, VM.Item>!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureDataSource()
        configureBinding()
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let section = VM.Section(rawValue: section) else { return nil }
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerReuseIdentifier)
        header?.textLabel?.text = section.label.uppercased()
        return header
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        if item.key == .manifesto { // Tuyên ngôn
            let vc = ManifestoTableViewController(style: .grouped)
            navigationController?.pushViewController(vc, animated: true)
            return
        }

        if item.key == .role { // Vai trò
            let vc = RoleTableViewController(style: .grouped)
            navigationController?.pushViewController(vc, animated: true)
            return
        }
    }
}

extension ProfileTableViewController: ScreenConfiguration {
    func configureNavigationBar() {
        navigationItem.title = "Hồ sơ"
        navigationController?.navigationBar.tintColor = AppColor.primary
    }

    func configureDataSource() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: headerReuseIdentifier)

        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { [unowned self] tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
            var content = cell.defaultContentConfiguration()
            content.image = UIImage(systemName: item.image, withConfiguration: UIImage.SymbolConfiguration(pointSize: 18))
            content.text = item.title
            content.prefersSideBySideTextAndSecondaryText = !item.isNav
            if !item.subTitle.isEmpty {
                content.secondaryText = item.subTitle
            }
            cell.accessoryType = item.isNav ? .disclosureIndicator : .none

            if let itemData = viewModel.menu.filter({ item.id == $0.id }).first, itemData.toggle != nil {
                let switchView = UISwitch(frame: .zero)
                switchView.setOn(itemData.toggle!, animated: true)
                switchView.tag = indexPath.row
                switchView.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
                cell.accessoryView = switchView
            }

            cell.tintColor = AppColor.primary
            cell.contentConfiguration = content

            return cell
        })
        var snapshot = NSDiffableDataSourceSnapshot<VM.Section, VM.Item>()
        snapshot.appendSections([.profile, .featured, .habits, .info])

        snapshot.appendItems(viewModel.menu.filter { $0.group == .profile }, toSection: .profile)
        snapshot.appendItems(viewModel.menu.filter { $0.group == .featured }, toSection: .featured)
        snapshot.appendItems(viewModel.menu.filter { $0.group == .habits }, toSection: .habits)
        snapshot.appendItems(viewModel.menu.filter { $0.group == .info }, toSection: .info)

        DispatchQueue.main.async { [unowned self] in
            dataSource.apply(snapshot, animatingDifferences: true)
        }
    }

    func configureBinding() {}
}

extension ProfileTableViewController {
    @objc func switchChanged(_ sender: UISwitch) {}
}
