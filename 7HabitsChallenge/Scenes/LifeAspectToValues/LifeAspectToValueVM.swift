//
//  LifeAspectToValueVM.swift
//  7HabitsChallenge
//
//  Created by Bui V Chanh on 03/08/2021.
//

import Foundation

enum LifeThings {
    enum Aspect: Int, CaseIterable, Hashable {
        case none
        case marriage, family, money, career, pelf, satisfaction, friend, enemy, attendance, yourself, principle
        var title: String {
            switch self {
            case .none: return ""
            // case .noneEdit: return ""
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

struct LifeAspectToValue: Hashable {
    let id = UUID()
    var content: String
    var values: LifeThings.Values
}

class LifeAspectToValuesVM {
    var aspect: LifeThings.Aspect
    var matrix: [LifeAspectToValue]

    init(aspect: LifeThings.Aspect) {
        self.aspect = aspect
        matrix = []
    }

    func fillMatrix() {
        switch aspect {
        case .none: matrix = []
        case .marriage: matrix = getMarriageMatrix()
        case .family: matrix = getFamilyMatrix()
        case .money: matrix = getMoneyMatrix()
        case .career: matrix = getCareerMatrix()
        case .pelf: matrix = getPelfMatrix()
        case .satisfaction: matrix = getSatisfactionMatrix()
        case .friend: matrix = getFriendMatrix()
        case .enemy: matrix = getEnemyMatrix()
        case .attendance: matrix = getAttendanceMatrix()
        case .yourself: matrix = getYourselfMatrix()
        case .principle: matrix = getPrincipleMatrix()
        }
    }

    private func getMarriageMatrix() -> [LifeAspectToValue] {
        return [
            LifeAspectToValue(content: "Nếu bạn lấy \"\(aspect.title)\" làm trọng tâm của cuộc sống", values: .none),
            LifeAspectToValue(content: "Nếu bạn lấy \"\(aspect.title)\" làm trọng tâm của cuộc sống Nếu bạn lấy \"\(aspect.title)\" làm trọng tâm của cuộc sống Nếu bạn lấy \"\(aspect.title)\" làm trọng tâm của cuộc sống Nếu bạn lấy \"\(aspect.title)\" làm trọng tâm của cuộc sống v v Nếu bạn lấy \"\(aspect.title)\" làm trọng tâm của cuộc sống v v v Nếu bạn lấy \"\(aspect.title)\" làm trọng tâm của cuộc sống v Nếu bạn lấy \"\(aspect.title)\" làm trọng tâm của cuộc sống Nếu bạn lấy \"\(aspect.title)\" làm trọng tâm của cuộc sống v v Nếu bạn lấy \"\(aspect.title)\" làm trọng tâm của cuộc sống", values: .peace),
            LifeAspectToValue(content: "", values: .leadership),
            LifeAspectToValue(content: "", values: .intellect),
            LifeAspectToValue(content: "", values: .power),
        ]
    }

    private func getFamilyMatrix() -> [LifeAspectToValue] {
        return [
            LifeAspectToValue(content: "Nếu bạn lấy \"\(aspect.title)\" làm trọng tâm của cuộc sống", values: .none),
            LifeAspectToValue(content: "", values: .peace),
            LifeAspectToValue(content: "", values: .leadership),
            LifeAspectToValue(content: "", values: .intellect),
            LifeAspectToValue(content: "", values: .power),
        ]
    }

    private func getMoneyMatrix() -> [LifeAspectToValue] {
        return [
            LifeAspectToValue(content: "Nếu bạn lấy \"\(aspect.title)\" làm trọng tâm của cuộc sống", values: .none),
            LifeAspectToValue(content: "", values: .peace),
            LifeAspectToValue(content: "", values: .leadership),
            LifeAspectToValue(content: "", values: .intellect),
            LifeAspectToValue(content: "", values: .power),
        ]
    }

    private func getCareerMatrix() -> [LifeAspectToValue] {
        return [
            LifeAspectToValue(content: "Nếu bạn lấy \"\(aspect.title)\" làm trọng tâm của cuộc sống", values: .none),
            LifeAspectToValue(content: "", values: .peace),
            LifeAspectToValue(content: "", values: .leadership),
            LifeAspectToValue(content: "", values: .intellect),
            LifeAspectToValue(content: "", values: .power),
        ]
    }

    private func getPelfMatrix() -> [LifeAspectToValue] {
        return [
            LifeAspectToValue(content: "Nếu bạn lấy \"\(aspect.title)\" làm trọng tâm của cuộc sống", values: .none),
            LifeAspectToValue(content: "", values: .peace),
            LifeAspectToValue(content: "", values: .leadership),
            LifeAspectToValue(content: "", values: .intellect),
            LifeAspectToValue(content: "", values: .power),
        ]
    }

    private func getSatisfactionMatrix() -> [LifeAspectToValue] {
        return [
            LifeAspectToValue(content: "Nếu bạn lấy \"\(aspect.title)\" làm trọng tâm của cuộc sống", values: .none),
            LifeAspectToValue(content: "", values: .peace),
            LifeAspectToValue(content: "", values: .leadership),
            LifeAspectToValue(content: "", values: .intellect),
            LifeAspectToValue(content: "", values: .power),
        ]
    }

    private func getFriendMatrix() -> [LifeAspectToValue] {
        return [
            LifeAspectToValue(content: "Nếu bạn lấy \"\(aspect.title)\" làm trọng tâm của cuộc sống", values: .none),
            LifeAspectToValue(content: "", values: .peace),
            LifeAspectToValue(content: "", values: .leadership),
            LifeAspectToValue(content: "", values: .intellect),
            LifeAspectToValue(content: "", values: .power),
        ]
    }

    private func getEnemyMatrix() -> [LifeAspectToValue] {
        return [
            LifeAspectToValue(content: "Nếu bạn lấy \"\(aspect.title)\" làm trọng tâm của cuộc sống", values: .none),
            LifeAspectToValue(content: "", values: .peace),
            LifeAspectToValue(content: "", values: .leadership),
            LifeAspectToValue(content: "", values: .intellect),
            LifeAspectToValue(content: "", values: .power),
        ]
    }

    private func getAttendanceMatrix() -> [LifeAspectToValue] {
        return [
            LifeAspectToValue(content: "Nếu bạn lấy \"\(aspect.title)\" làm trọng tâm của cuộc sống", values: .none),
            LifeAspectToValue(content: "", values: .peace),
            LifeAspectToValue(content: "", values: .leadership),
            LifeAspectToValue(content: "", values: .intellect),
            LifeAspectToValue(content: "", values: .power),
        ]
    }

    private func getYourselfMatrix() -> [LifeAspectToValue] {
        return [
            LifeAspectToValue(content: "Nếu bạn lấy \"\(aspect.title)\" làm trọng tâm của cuộc sống", values: .none),
            LifeAspectToValue(content: "", values: .peace),
            LifeAspectToValue(content: "", values: .leadership),
            LifeAspectToValue(content: "", values: .intellect),
            LifeAspectToValue(content: "", values: .power),
        ]
    }

    private func getPrincipleMatrix() -> [LifeAspectToValue] {
        return [
            LifeAspectToValue(content: "Nếu bạn lấy \"\(aspect.title)\" làm trọng tâm của cuộc sống", values: .none),
            LifeAspectToValue(content: "", values: .peace),
            LifeAspectToValue(content: "", values: .leadership),
            LifeAspectToValue(content: "", values: .intellect),
            LifeAspectToValue(content: "", values: .power),
        ]
    }
}
