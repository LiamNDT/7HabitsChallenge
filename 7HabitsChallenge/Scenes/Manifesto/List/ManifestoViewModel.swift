//
//  ManifestoViewModel.swift
//  7HabitsChallenge
//
//  Created by Bui V Chanh on 05/08/2021.
//

import Foundation

class ManifestoViewModel {
    enum Section {
        case main
    }

    struct ManifestoItem: Hashable {
        static func == (lhs: ManifestoItem, rhs: ManifestoItem) -> Bool {
            lhs.id == rhs.id
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }

        var id: UUID
        var content: String
        var aspects: [LifeThings.Aspect]
    }

    typealias BindingToView = () -> ()

    var binding: BindingToView?
    var listOfManifesto: [ManifestoItem]? {
        didSet {
            binding?()
        }
    }

    var repository: DefinitionRepository

    init() {
        repository = DefinitionRepository()
        // listOfManifesto = []
    }

    func fetch() {
        repository.retrieve { [unowned self] list in
            if listOfManifesto == nil {
                listOfManifesto = list
            } else {
                listOfManifesto?.append(contentsOf: list)
            }
        }
    }

    func save(item: ManifestoItem) {
        repository.save(item) { [unowned self] result in
            if let addedManifesto = result {
                listOfManifesto?.append(addedManifesto)
            }
        }
    }
}
