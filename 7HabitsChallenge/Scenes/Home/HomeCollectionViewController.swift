//
//  HomeCollectionViewController.swift
//  7HabitsChallenge
//
//  Created by Bui V Chanh on 07/08/2021.
//

import UIKit

class HomeCollectionViewController: UICollectionViewController {
    typealias VM = HomeViewModel
    var viewModel = HomeViewModel()

    var dataSource: UICollectionViewDiffableDataSource<VM.Section, VM.Item>!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureDataSource()
        configureBinding()
    }
}

extension HomeCollectionViewController: ScreenConfiguration {
    func configureNavigationBar() {
        navigationItem.title = "Trang chủ"
        navigationController?.navigationBar.isHidden = true
    }

    func configureDataSource() {
        collectionView.backgroundColor = AppColor.background
        collectionView.register(TopCollectionViewCell.self, forCellWithReuseIdentifier: TopCollectionViewCell.reuseIdentifier)
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { [unowned self] collectionView, indexPath, item in
            guard let section = VM.Section(rawValue: indexPath.section) else { return nil }
            if section == .main {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopCollectionViewCell.reuseIdentifier, for: indexPath) as! TopCollectionViewCell
                cell.titleLabel.text = item.title
                return cell
            }
            return nil
        })

        var snapshot = NSDiffableDataSourceSnapshot<VM.Section, VM.Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems([
            VM.Item(title: "Tôi là một người thành đạt, hàng ngày tôi giành 16 tiếng để làm việc và học hỏi thêm nhiều điều mới."),
            VM.Item(title: "Tôi là một người chồng tốt"),
            VM.Item(title: "Tôi muốn sống thoải mái về tài chính"),
            VM.Item(title: "Cuộc sống này tràn ngập liều tích cực"),
        ],
        toSection: .main)
        DispatchQueue.main.async { [unowned self] in
            dataSource.apply(snapshot, animatingDifferences: false)
        }
    }

    func configureBinding() {}
}

extension HomeCollectionViewController {
    static func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionNumber: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let section = VM.Section(rawValue: sectionNumber) else { return nil }
            if section == .main {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupFractionalWidth = CGFloat(layoutEnvironment.container.effectiveContentSize.width > 500 ? 0.425 : 0.75)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(groupFractionalWidth), heightDimension: .estimated(100))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.interGroupSpacing = 20
                section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 20)
                return section
            }
            return nil
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20

        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: config)
        return layout
    }
}
