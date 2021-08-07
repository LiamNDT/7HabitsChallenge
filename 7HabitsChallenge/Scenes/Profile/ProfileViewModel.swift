//
//  ProfileViewModel.swift
//  7HabitsChallenge
//
//  Created by Bui V Chanh on 07/08/2021.
//

import UIKit

class ProfileViewModel {
    enum Section: Int, CaseIterable {
        case profile
        case featured
        case info
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
        var toggle: Bool? = nil
        var isNav: Bool = false
        var group: Section
    }

    var menu: [Item]
    init() {
        menu = [
            Item(image: "person.circle", title: "Thông tin cá nhân", subTitle: "Nói cho chúng tôi biết bạn là ai", isNav: true, group: .profile),
            Item(image: "doc.append", title: "Tuyên ngôn", subTitle: "Định hình con người bạn", isNav: true, group: .profile),
            Item(image: "person.2.square.stack.fill", title: "Vai trò", subTitle: "Bạn là những ai?", isNav: true, group: .profile),

            Item(image: "dollarsign.circle", title: "Donated", subTitle: "Ủng hộ chúng tôi", isNav: true, group: .featured),
            Item(image: "lifepreserver.fill", title: "Trọng tâm cuộc sống", isNav: true, group: .featured),
            Item(image: "die.face.4", title: "Góc phần tư thứ hai (II)", isNav: true, group: .featured),
            Item(image: "graduationcap", title: "7 thói quen tích cực", isNav: true, group: .featured),

            Item(image: "key.fill", title: "Passcode", toggle: false, isNav: false, group: .info),
            Item(image: "faceid", title: "FaceID", isNav: false, group: .info),
            Item(image: "", title: "Quyền riêng tư", isNav: true, group: .info),
            Item(image: "", title: "Điều khoản sử dụng", isNav: true, group: .info),
            Item(image: "", title: "Phiên bản", subTitle: "v1.0.0", isNav: false, group: .info)
        ]
    }
}
