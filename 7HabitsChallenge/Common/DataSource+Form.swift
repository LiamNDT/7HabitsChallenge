//
//  DataSource+SectionField.swift
//  7HabitsChallenge
//
//  Created by Bui V Chanh on 03/08/2021.
//

import Foundation

enum Form {
    enum Section {
        case main
    }

    enum ControlType {
        case label, textField
    }

    struct Field: Hashable {
        let id = UUID()
        let control: ControlType
        let value: String
    }
}
