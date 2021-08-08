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

        var id = UUID()
        var code: String = ""
        var name: String = ""
        var content: String = ""
        var icon: String = ""
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

    func save(item: Item) {
        repository.save(item) { [unowned self] saved in
            if let saved = saved {
                listOfRole.append(saved)
                binding?([saved], .add)
            }
        }
    }

    func update(item: Item) {
        repository.update(item) { [unowned self] edited in
            if let edited = edited {
                listOfRole = listOfRole.filter { $0.id != edited.id }
                listOfRole.append(edited)
                binding?([edited], .update)
            }
        }
    }

    func delete(item: Item) {
        repository.delete(item) { [unowned self] result in
            if let deleted = result {
                listOfRole.removeAll(where: { $0.id == deleted.id })
                binding?([deleted], .remove)
            }
        }
    }
}
