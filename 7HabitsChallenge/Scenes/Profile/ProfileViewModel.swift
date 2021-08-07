//
//  ProfileViewModel.swift
//  7HabitsChallenge
//
//  Created by Bui V Chanh on 07/08/2021.
//

import UIKit

class ProfileViewModel {
    enum Section: Int, CaseIterable {
        case profile, featured, habits, info
        var label: String {
            switch self {
                case .habits: return "7 Thói quen tích cực"
                case .info: return "Về chúng tôi"
                default: return ""
            }
        }
    }

    struct Item: Hashable {
        static func == (lhs: Item, rhs: Item) -> Bool {
            lhs.id == rhs.id
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }

        let id = UUID()
        var image: String
        var title: String
        var subTitle: String = ""
        var toggle: Bool?
        var isNav: Bool = true
        var group: Section
        var key: MenuKey

        init(with menuKey: MenuKey, on group: Section, subTitle: String = "", toggle: Bool? = nil) {
            title = menuKey.label.0
            image = menuKey.label.1
            isNav = menuKey.label.2
            key = menuKey
            self.group = group
            self.subTitle = subTitle
            self.toggle = toggle
        }
    }

    enum MenuKey: Int, CaseIterable {
        case basicInfo, manifesto, role, passCode, faceID
        case donated, centerOfLife, secondOfQuadrant
        case habit1, habit2, habit3, habit4, habit5, habit6, habit7
        case privacy, termsOfService, version

        var label: (String, String, Bool) {
            switch self {
                case .basicInfo: return ("Thông tin cá nhân", "person.circle", true)
                case .manifesto: return ("Tuyên ngôn / Sứ mệnh", "doc.append", true)
                case .role: return ("Vai trò", "person.2.square.stack.fill", true)
                case .passCode: return ("Passcode", "key.fill", false)
                case .faceID: return ("FaceID", "faceid", false)
                case .donated: return ("Ủng hộ chúng tôi", "dollarsign.circle", true)
                case .centerOfLife: return ("Trọng tâm cuộc sống", "lifepreserver.fill", true)
                case .secondOfQuadrant: return ("Góc phần tư thứ 2 (II)", "die.face.4", true)
                case .habit1: return ("Sống kiểu kiến tạo", "1.circle", true)
                case .habit2: return ("Bắt đầu bằng đích đến", "2.circle", true)
                case .habit3: return ("Ưu tiên điều quan trọng", "3.circle", true)
                case .habit4: return ("Tư duy cùng thắng", "4.circle", true)
                case .habit5: return ("Thấu hiểu rồi được hiểu", "5.circle", true)
                case .habit6: return ("Cùng tạo cách mới", "6.circle", true)
                case .habit7: return ("Rèn mới bản thân", "7.circle", true)
                case .privacy: return ("Quyền riêng tư", "", true)
                case .termsOfService: return ("Điều khoản sử dụng dịch vụ", "", true)
                case .version: return ("Phiên bản", "", false)
            }
        }
    }

    var menu: [Item]
    init() {
        menu = [
            Item(with: .basicInfo, on: .profile),
            Item(with: .manifesto, on: .profile, subTitle: "Định hình con người bạn"),
            Item(with: .role, on: .profile, subTitle: "Bạn là những ai?"),
            Item(with: .passCode, on: .profile, toggle: false),
            Item(with: .faceID, on: .profile),

            Item(with: .donated, on: .featured),
            Item(with: .centerOfLife, on: .featured),
            Item(with: .secondOfQuadrant, on: .featured),

            Item(with: .habit1, on: .habits),
            Item(with: .habit2, on: .habits),
            Item(with: .habit3, on: .habits),
            Item(with: .habit4, on: .habits),
            Item(with: .habit5, on: .habits),
            Item(with: .habit6, on: .habits),
            Item(with: .habit7, on: .habits),

            Item(with: .privacy, on: .info),
            Item(with: .termsOfService, on: .info),
            Item(with: .version, on: .info, subTitle: "v1.0.0"),
        ]
    }
}
