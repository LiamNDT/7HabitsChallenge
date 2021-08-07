//
//  RoleViewModel.swift
//  7HabitsChallenge
//
//  Created by Bui V Chanh on 07/08/2021.
//

import Foundation

class RoleViewModel {
    enum Section: Int, CaseIterable {
        case main
    }

    struct Item: Hashable {
        static func == (lhs: Item, rhs: Item) -> Bool {
            lhs.id == rhs.id
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }

        var id: UUID
        var code: String
        var name: String
        var content: String
        var icon: String
    }

    enum Action: Int, CaseIterable {
        case new, view, edit
    }

    enum BindingAction {
        case add, remove, update
    }

    typealias BindingToView = ([Item], BindingAction) -> ()

    var binding: BindingToView?
    var listOfRole: [Item]
    var repository: RoleRepository

    init() {
        listOfRole = []
        repository = RoleRepository()
    }

    func fetch() {
        repository.retrieve { [unowned self] roles in
            listOfRole.append(contentsOf: roles)
            binding?(roles, .add)
        }
    }
}
