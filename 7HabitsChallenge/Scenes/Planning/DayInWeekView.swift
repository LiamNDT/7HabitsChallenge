//
//  DayInWeekView.swift
//  7HabitsChallenge
//
//  Created by Bui V Chanh on 07/08/2021.
//

import UIKit

class DayInWeekView: UIView {
    enum DayInWeek: Int, CaseIterable {
        case mon, tue, wed, thu, fri, sat, sun
        var shortTitle: String {
            switch self {
            case .mon: return "T2"
            case .tue: return "T3"
            case .wed: return "T4"
            case .thu: return "T5"
            case .fri: return "T6"
            case .sat: return "T7"
            case .sun: return "CN"
            }
        }
    }
}

extension DayInWeekView {
    func configure(isHeader: Bool = true, startDate: Int = 1, width: CGFloat, height: CGFloat = 30) {
        let widthEach = width / CGFloat(DayInWeek.allCases.count)
        for i in 0 ..< DayInWeek.allCases.count {
            let dayButton = UIButton(frame: CGRect(x: CGFloat(i) * widthEach, y: 0, width: widthEach, height: height))
            dayButton.backgroundColor = .clear
            dayButton.setTitleColor(AppColor.primary, for: .normal)
            dayButton.tintColor = AppColor.primary
            if isHeader {
                dayButton.setTitle(DayInWeek(rawValue: i)?.shortTitle, for: .normal)
            } else {
                let date = Date()
                let calendar = Calendar.current
                let currentDayInMonth = calendar.component(.day, from: date)
                if currentDayInMonth == i + startDate {
                    let configure = UIImage.SymbolConfiguration(pointSize: 25)
                    dayButton.setImage(UIImage(systemName: "\(currentDayInMonth).circle.fill", withConfiguration: configure), for: .normal)
                } else {
                    dayButton.setTitle(String(describing: startDate + i), for: .normal)
                }
            }

            addSubview(dayButton)
        }
    }
}
