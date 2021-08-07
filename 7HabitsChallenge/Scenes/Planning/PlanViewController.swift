//
//  PlanTableViewController.swift
//  7HabitsChallenge
//
//  Created by Bui V Chanh on 07/08/2021.
//

import UIKit

class PlanViewController: UIViewController {
    var dayInWeek: DayInWeekView!
    var weeks: DayInWeekView!
    var tableView: UITableView!
    var dataSource: PlanDataSource!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureHierachy()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        NSLayoutConstraint.activate([
            dayInWeek.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            dayInWeek.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dayInWeek.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dayInWeek.heightAnchor.constraint(equalToConstant: 30),

            weeks.topAnchor.constraint(equalTo: dayInWeek.bottomAnchor, constant: 5),
            weeks.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weeks.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            weeks.heightAnchor.constraint(equalToConstant: 40),

            tableView.topAnchor.constraint(equalTo: weeks.bottomAnchor, constant: 5),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

        ])
    }

    class PlanDataSource: UITableViewDiffableDataSource<Int, Int> {}
}

extension PlanViewController {
    func configureNavigationBar() {
        let iconBarConfigure = UIImage.SymbolConfiguration(pointSize: 18)
        let backwardButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward.circle", withConfiguration: iconBarConfigure),
                                             style: .plain, target: self, action: #selector(changeView))

        let forwardButton = UIBarButtonItem(image: UIImage(systemName: "chevron.forward.circle", withConfiguration: iconBarConfigure),
                                            style: .plain, target: self, action: #selector(changeView))

        let switchDateButton = UIBarButtonItem(title: "Tuần 31", style: .plain, target: self, action: #selector(changeView))

        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus", withConfiguration: iconBarConfigure),
                                        style: .plain, target: self, action: #selector(changeView))

        navigationItem.leftBarButtonItems = [backwardButton, switchDateButton, forwardButton]
        navigationItem.rightBarButtonItem = addButton
        navigationController?.navigationBar.tintColor = AppColor.primary
        navigationItem.title = "Thg12 - 2021"
    }

    func configureHierachy() {
        dayInWeek = DayInWeekView()
        dayInWeek.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dayInWeek)
        dayInWeek.configure(width: view.frame.width)

        weeks = DayInWeekView()
        weeks.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(weeks)
        weeks.configure(isHeader: false, startDate: 2, width: view.frame.width, height: 40)

        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellPla")
        tableView.delegate = self
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "headerFooterPlan")
        view.addSubview(tableView)
    }
}

extension PlanViewController: UITableViewDelegate {
    @objc func changeView(_ sender: UIBarButtonItem) {}
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
