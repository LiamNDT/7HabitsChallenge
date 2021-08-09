//
//  RoleCleanRouter.swift
//  7HabitsChallenge
//
//  Created by Bui V Chanh on 08/08/2021.
//

import Foundation

class RoleCleanDefaultRouter: RoleCleanRouter {
    var presenter: RoleCleanPresenter?
    
    func navigateCreator() {}
    
    func navigateDetailView(with item: RoleCleanItem) {}
}
