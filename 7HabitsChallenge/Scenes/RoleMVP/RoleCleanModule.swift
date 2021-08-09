//
//  RoleContract.swift
//  7HabitsChallenge
//
//  Created by Bui V Chanh on 08/08/2021.
//

import UIKit

protocol RoleCleanBindingState {
    func handleRequest(_ items: [RoleCleanItem], dataSource: RoleCleanDataSource)
}

protocol RoleCleanView {
    // delegate: logic app
    var presenter: RoleCleanPresenter? { get set }

    // only logic view
    func displayLoading()
    func confirmDelete()
    func binding(_ items: [RoleCleanItem], event: RoleCleanBindingState)
}

protocol RoleCleanPresenter {
    // navigation of app: present modal or push view controller
    var router: RoleCleanRouter? { get set }
    // transform data from (service: coredata/background.../nework API/other..) repository layer
    var interactor: RoleCleanInteractor? { get set }
    var view: RoleCleanView? { get set }

    // hold data to display on view
    var listOfRole: [RoleCleanItem]? { get set }

    func didLoad()
    func didTapAddNew()
    func didTapRoleInfo(_ item: RoleCleanItem)
    func didSelectedRole(_ item: RoleCleanItem)
    func didTapDelete(_ item: RoleCleanItem)
}

protocol RoleCleanInteractor {
    var presenter: RoleCleanPresenter? { get set }

    func fetchByList(completion: @escaping ([RoleCleanItem]) -> ())
    func create(_ item: RoleCleanItem, completion: @escaping (RoleCleanItem?) -> ())
    func update(_ item: RoleCleanItem, completion: @escaping (RoleCleanItem?) -> ())
    func delete(_ item: RoleCleanItem, completion: @escaping (RoleCleanItem?) -> ())
}

protocol RoleCleanRouter {
    var presenter: RoleCleanPresenter? { get set }

    func navigateCreator()
    func navigateDetailView(with item: RoleCleanItem)
}

enum RoleCleanSection {
    case main
}

struct RoleCleanItem: Hashable {
    static func == (lhs: RoleCleanItem, rhs: RoleCleanItem) -> Bool {
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

class RoleCleanModule {
    func build() -> UIViewController {
        let view = RoleCleanDefaultView(style: .grouped)
        let interactor = RoleCleanDefaultInteractor(repository: RoleCleanRepository())
        let presenter = RoleCleanDefaultPresenter()
        let router = RoleCleanDefaultRouter()

        view.presenter = presenter

        presenter.interactor = interactor
        presenter.view = view
        presenter.router = router

        interactor.presenter = presenter

        return view
    }
}
