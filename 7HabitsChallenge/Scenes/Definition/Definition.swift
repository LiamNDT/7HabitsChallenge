//
//  Definition.swift
//  7HabitsChallenge
//
//  Created by Bui V Chanh on 03/08/2021.
//

import Foundation

class Definition: Hashable {
    static func == (lhs: Definition, rhs: Definition) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }

    var id = UUID()
    var content: String = ""
    var aspects: [LifeThings.Aspect] = []
}

enum LifeThings {
    enum Aspect: Int, CaseIterable, Hashable {
        case none, noneEdit
        case marriage, family, money, career, pelf, satisfaction, friend, enemy, attendance, yourself, principle
        var title: String {
            switch self {
            case .none: return ""
            case .noneEdit: return ""
            case .marriage: return "Hôn nhân"
            case .family: return "Gia đình"
            case .money: return "Tiền bạc"
            case .career: return "Công việc"
            case .pelf: return "Tài sản sở hữu"
            case .satisfaction: return "Sự thoả mãn"
            case .friend: return "Bạn bè"
            case .enemy: return "Kẻ thù"
            case .attendance: return "Công việc phụng sự"
            case .yourself: return "Bản thân"
            case .principle: return "Nguyên lý"
            }
        }
    }

    enum Values: Int, CaseIterable {
        case none
        case peace, leadership, intellect, power
        var title: String {
            switch self {
            case .none: return ""
            case .peace: return "Sự an nhiên"
            case .leadership: return "Sự dẫn đường"
            case .intellect: return "Trí tuệ"
            case .power: return "Sức mạnh"
            }
        }
    }

    static func transform(_ stringValue: String) -> Aspect {
        Aspect.allCases.filter { stringValue == "\($0)" }.first ?? .none
    }
}
