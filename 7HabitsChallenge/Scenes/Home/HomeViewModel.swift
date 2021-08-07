//
//  HomeViewModel.swift
//  7HabitsChallenge
//
//  Created by Bui V Chanh on 07/08/2021.
//

import Foundation

class HomeViewModel {
    enum Section: Int, CaseIterable {
        case main, task, chart
    }

    struct Item: Hashable {
        static func == (lhs: Item, rhs: Item) -> Bool {
            lhs.id == rhs.id
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }

        let id = UUID()
        let title: String
    }
}
