//
//  KeychainWrapper.swift
//  ECATALOGUE
//
//  Created by Bui V Chanh on 27/07/2021.
//

import Foundation
import Security

public struct KeychainWrapper {
    let keychainQuery: KeychainStoreQueryable
    
    init(keychainQuery: KeychainStoreQueryable = GenericPasswordQueryable(service: "AppKeychainServices")) {
        self.keychainQuery = keychainQuery
    }
    
    func setValue(_ value: String, for userAccount: String) throws {
        guard let encodedPassword = value.data(using: .utf8) else {
            throw KeychainWrapperError.string2DataConversionError
        }
      
        var query = keychainQuery.query
        query[String(kSecAttrAccount)] = userAccount
      
        var status = SecItemCopyMatching(query as CFDictionary, nil)
        switch status {
        case errSecSuccess:
            var attributesToUpdate: [String: Any] = [:]
            attributesToUpdate[String(kSecValueData)] = encodedPassword
            
            status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            
            if status != errSecSuccess {
                throw error(from: status)
            }
        case errSecItemNotFound:
            query[String(kSecValueData)] = encodedPassword
            status = SecItemAdd(query as CFDictionary, nil)
            if status != errSecSuccess {
                throw error(from: status)
            }
        default:
            throw error(from: status)
        }
    }
    
    func getValue(for userAccount: String) throws -> String? {
        var query = keychainQuery.query
        query[String(kSecMatchLimit)] = kSecMatchLimitOne
        query[String(kSecReturnAttributes)] = kCFBooleanTrue
        query[String(kSecReturnData)] = kCFBooleanTrue
        query[String(kSecAttrAccount)] = userAccount

        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, $0)
        }

        switch status {
        case errSecSuccess:
            guard
                let queriedItem = queryResult as? [String: Any],
                let passwordData = queriedItem[String(kSecValueData)] as? Data,
                let password = String(data: passwordData, encoding: .utf8)
            else {
                throw KeychainWrapperError.data2StringConversionError
            }
            
            return password
        case errSecItemNotFound:
            return nil
        default:
            throw error(from: status)
        }
    }
    
    public func removeValue(for userAccount: String) throws {
        var query = keychainQuery.query
        query[String(kSecAttrAccount)] = userAccount

        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw error(from: status)
        }
    }
    
    public func removeAllValues() throws {
        let query = keychainQuery.query

        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw error(from: status)
        }
    }
    
    private func error(from status: OSStatus) -> KeychainWrapperError {
        var message: String
        if #available(iOS 11.3, *) {
            if let msg = SecCopyErrorMessageString(status, nil) as String? {
                message = msg
            } else {
                message = NSLocalizedString("Unhandled Error", comment: "")
            }
        } else {
            // Fallback on earlier versions
            message = "Unhandled Error"
        }
        
        return KeychainWrapperError.unhandledError(message: message)
    }
}
