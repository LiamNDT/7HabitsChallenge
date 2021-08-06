//
//  ManifestoViewModel.swift
//  7HabitsChallenge
//
//  Created by Bui V Chanh on 05/08/2021.
//

import Foundation

class ManifestoViewModel {
    // TODO: hanlder error on request
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

        mutating func updateContentAndAspects(_ content: String?, _ aspects: [LifeThings.Aspect]?) {
            if let content = content {
                self.content = content
            }
            if let aspects = aspects {
                self.aspects = aspects
            }
        }
    }

    enum Event {
        case add, remove, update
    }

    typealias BindingToView = ([ManifestoItem], Event) -> ()

    var binding: BindingToView?

    var listOfManifesto: [ManifestoItem]
    var repository: DefinitionRepository

    init() {
        repository = DefinitionRepository()
        listOfManifesto = []
    }

    func fetch() {
        repository.retrieve { [unowned self] list in
            listOfManifesto.append(contentsOf: list)
            binding?(list, .add)
        }
    }

    func delete(item: ManifestoItem) {
        repository.delete(item) { [unowned self] result in
            if let deleted = result {
                listOfManifesto.removeAll(where: { $0.id == deleted.id })
                binding?([deleted], .remove)
            }
        }
    }

    func save(item: ManifestoItem) {
        repository.save(item) { [unowned self] result in
            if let addedManifesto = result {
                listOfManifesto.append(addedManifesto)
                binding?([addedManifesto], .add)
            }
        }
    }

    func update(item: ManifestoItem) {
        repository.update(item) { [unowned self] result in
            if let updatedManifesto = result {
                listOfManifesto = listOfManifesto.filter { $0.id != updatedManifesto.id }
                listOfManifesto.append(updatedManifesto)
                binding?([updatedManifesto], .update)
            }
        }
    }
}
