//
//  DefinitionTableViewController.swift
//  7HabitsChallenge
//
//  Created by Bui V Chanh on 03/08/2021.
//

import UIKit

class DefinitionTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTitle(title: "Tuyên ngôn", largeMode: false, hasSearchBar: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(goToCreate))
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
}

extension DefinitionTableViewController {
    @objc func goToCreate(_ sender: UIBarButtonItem) {
        let detailVC = DefinitionDetailViewController(style: .grouped)
        detailVC.configure(with: Definition(), isNew: true)
        let nav = UINavigationController(rootViewController:detailVC )
        navigationController?.present(nav, animated: true, completion: nil)
    }
}
