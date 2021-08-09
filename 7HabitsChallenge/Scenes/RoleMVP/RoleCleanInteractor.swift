//
//  RoleCleanInteractor.swift
//  7HabitsChallenge
//
//  Created by Bui V Chanh on 08/08/2021.
//

import Foundation

class RoleCleanDefaultInteractor: RoleCleanInteractor {
    var presenter: RoleCleanPresenter?
    
    let repository: RoleCleanRepository
    
    init(repository: RoleCleanRepository) {
        self.repository = repository
    }
    
    // Promise/Combine
    // readmore callback: javascript
    func fetchByList(completion: @escaping ([RoleCleanItem]) -> ()) {
        // TODO: - Receive data và transform data: RoleLocal(service know) -> RoleCleanItem(View know)
        repository.retrieve(completion: completion)
    }
    
    func create(_ item: RoleCleanItem, completion: @escaping (RoleCleanItem?) -> ()) {}
    
    func update(_ item: RoleCleanItem, completion: @escaping (RoleCleanItem?) -> ()) {}
    
    func delete(_ item: RoleCleanItem, completion: @escaping (RoleCleanItem?) -> ()) {}
}
