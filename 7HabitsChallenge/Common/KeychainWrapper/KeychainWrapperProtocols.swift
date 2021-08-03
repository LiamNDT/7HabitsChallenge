//
//  KeychainWrapperProtocols.swift
//  ECATALOGUE
//
//  Created by Bui V Chanh on 27/07/2021.
//

import Foundation

public protocol KeychainStoreQueryable {
    var query: [String: Any] { get }
}

public struct GenericPasswordQueryable {
    let service: String
    let accessGroup: String?

    init(service: String, accessGroup: String? = nil) {
        self.service = service
        self.accessGroup = accessGroup
    }
}

extension GenericPasswordQueryable: KeychainStoreQueryable {
    public var query: [String: Any] {
        var query: [String: Any] = [:]

        query[String(kSecClass)] = kSecClassGenericPassword
        query[String(kSecAttrService)] = service

        // Access group if target environment is not simulator
        #if !targetEnvironment(simulator)
        if let accessGroup = accessGroup {
            query[String(kSecAttrAccessGroup)] = accessGroup
        }
        #endif

        return query
    }
}
