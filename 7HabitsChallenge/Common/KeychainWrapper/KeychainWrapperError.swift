//
//  KeychainWrapperError.swift
//  ECATALOGUE
//
//  Created by Bui V Chanh on 27/07/2021.
//

import Foundation

public enum KeychainWrapperError: Error {
    case string2DataConversionError
    case data2StringConversionError
    case unhandledError(message: String)
}

extension KeychainWrapperError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .string2DataConversionError:
            return NSLocalizedString("String to Data conversion error", comment: "")
        case .data2StringConversionError:
            return NSLocalizedString("Data to String conversion error", comment: "")
        case .unhandledError(let message):
            return NSLocalizedString(message, comment: "")
        }
    }
}
