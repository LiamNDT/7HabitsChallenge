//
//  LifeAspectToValuesTableViewController.swift
//  7HabitsChallenge
//
//  Created by Bui V Chanh on 03/08/2021.
//

import UIKit

class LifeAspectToValuesTableVC: UITableViewController {
    let defaultCellReuseIdentifier = "LifeAspectToValuesCell"
    let defaultHeaderReuseIdentifier = "LifeAspectToValuesHeader"

    private var viewModel: LifeAspectToValuesVM
    var dataSource: UITableViewDiffableDataSource<LifeThings.Values, LifeAspectToValue>!

    init(aspect: LifeThings.Aspect) {
        self.viewModel = LifeAspectToValuesVM(aspect: aspect)
        super.init(style: .grouped)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTitle(title: viewModel.aspect.title, largeMode: false, hasSearchBar: false)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: defaultCellReuseIdentifier)
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: defaultHeaderReuseIdentifier)
        viewModel.fillMatrix()
        configureDataSource()
    }

    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<LifeThings.Values, LifeAspectToValue>(tableView: tableView, cellProvider: { tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: self.defaultCellReuseIdentifier, for: indexPath)
            var content = cell.defaultContentConfiguration()
            content.text = item.content
            content.textProperties.color = AppColor.black
            cell.isUserInteractionEnabled = false
            cell.contentConfiguration = content
            return cell
        })

        var snapshot = NSDiffableDataSourceSnapshot<LifeThings.Values, LifeAspectToValue>()
        snapshot.appendSections(LifeThings.Values.allCases)
        viewModel.matrix.forEach { snapshot.appendItems([$0], toSection: $0.values) }
        dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: defaultHeaderReuseIdentifier)
        header?.textLabel?.text = LifeThings.Values(rawValue: section)?.title.uppercased()
        return header
    }
}
