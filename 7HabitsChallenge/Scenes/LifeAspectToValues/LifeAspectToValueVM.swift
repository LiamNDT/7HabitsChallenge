//
//  LifeAspectToValueVM.swift
//  7HabitsChallenge
//
//  Created by Bui V Chanh on 03/08/2021.
//

import Foundation

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
            case .none, .noneEdit: matrix = []
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
