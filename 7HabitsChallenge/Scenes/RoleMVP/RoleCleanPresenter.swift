//
//  RoleCleanPresenter.swift
//  7HabitsChallenge
//
//  Created by Bui V Chanh on 08/08/2021.
//

import Foundation

class RoleCleanDefaultPresenter {
    var view: RoleCleanView?
    var router: RoleCleanRouter?
    var interactor: RoleCleanInteractor?

    var listOfRole: [RoleCleanItem]?
}

extension RoleCleanDefaultPresenter: RoleCleanPresenter {
    func didLoad() {
        interactor?.fetchByList(completion: { [unowned self] list in
            view?.binding(list, event: NewState())
        })
    }

    func didTapAddNew() {
        // prepare new module and navigate
    }

    func didTapRoleInfo(_ item: RoleCleanItem) {}

    func didSelectedRole(_ item: RoleCleanItem) {
        //prepate data & detailVC
        //View present/pushViewContrller Detail
    }

    func didTapDelete(_ item: RoleCleanItem) {}
}
