//
//  ManifestoViewModel.swift
//  7HabitsChallenge
//
//  Created by Bui V Chanh on 05/08/2021.
//

import Foundation

class ManifestoDetailViewModel {
    enum Action: Int, CaseIterable {
        case new, view, edit
    }

    enum Section: Int, CaseIterable {
        case content
        case aspects
        var label: String {
            switch self {
                case .content: return "Tuyên ngôn về bạn"
                case .aspects: return "Thuộc về khía cạnh cuộc sống"
            }
        }
    }

    struct Field: Hashable {
        static func == (lhs: Field, rhs: Field) -> Bool {
            lhs.id == rhs.id
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }

        let id = UUID()
        var content: String
        let aspect: LifeThings.Aspect?
    }

    typealias BindingFieldToView = (Field) -> ()

    var bindingFields: BindingFieldToView?
    var content: String
    var id: UUID
    var listOfAspect: [LifeThings.Aspect]!
    var action: Action!

    init(with manifesto: ManifestoViewModel.ManifestoItem, action: Action, addAction: ChangeAction?) {
        self.id = manifesto.id
        self.content = manifesto.content
        self.listOfAspect = manifesto.aspects
        self.action = action
        self.addAction = addAction
    }

    func onSelectField(_ field: Field) {
        if listOfAspect.contains(field.aspect!) {
            listOfAspect.removeAll { $0 == field.aspect }
        } else {
            listOfAspect.append(field.aspect!)
        }
        bindingFields?(field)
    }

    typealias ChangeAction = (ManifestoViewModel.ManifestoItem) -> ()

    var addAction: ChangeAction?

    func saveOrRestore() {
        if action == .new, let addAction = addAction {
            let newManifesto = ManifestoViewModel.ManifestoItem(id: id, content: content, aspects: listOfAspect)
            addAction(newManifesto)
        }
    }
}
