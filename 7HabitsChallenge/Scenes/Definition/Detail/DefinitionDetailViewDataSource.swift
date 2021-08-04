//
//  DefinitionDetailDataSource.swift
//  7HabitsChallenge
//
//  Created by Bui V Chanh on 03/08/2021.
//

import UIKit

class DefinitionDetailViewDataSource: UITableViewDiffableDataSource<DefinitionDetailViewDataSource.DefinitionSection, LifeThings.Aspect> {
    static let aspectEditCellReuseIdentifier = "aspectEditCellReuseIdentifier"

    enum DefinitionSection: Int, CaseIterable, Hashable {
        case content, aspects

        var displayText: String {
            switch self {
            case .content: return ""
            case .aspects: return "Thuộc về khía cạnh cuộc sống"
            }
        }

        func cellIdentifier() -> String {
            switch self {
            case .content: return TextFieldCell.reuseIdentifier
            case .aspects: return aspectEditCellReuseIdentifier
            }
        }
    }

    var definition: Definition

    init(definition: Definition, tableview: UITableView) {
        self.definition = definition
        super.init(tableView: tableview) { tableview, indexPath, aspect in
            guard let section = DefinitionSection(rawValue: indexPath.section) else { return nil }
            let cell = tableview.dequeueReusableCell(withIdentifier: section.cellIdentifier(), for: indexPath)

            if aspect == .noneEdit {
                let cell = cell as! TextFieldCell
                cell.textField.text = definition.content
                cell.icon.image = UIImage(systemName: "doc.append")
                cell.textField.placeholder = "Nhập tuyên ngôn về bạn"
                cell.isUserInteractionEnabled = false
                cell.textField.isUserInteractionEnabled = true
                cell.textField.becomeFirstResponder()
                cell.changedAction = { definition.content = $0 }
                cell.tintColor = AppColor.secondary
                return cell
            }

            if aspect == .none {
                var content = cell.defaultContentConfiguration()
                content.text = definition.content
                cell.tintColor = AppColor.secondary
                cell.contentConfiguration = content
                return cell
            }

            if aspect != .none, aspect != .noneEdit {
                var content = cell.defaultContentConfiguration()
                content.text = aspect.title
                content.image = UIImage(systemName: definition.aspects.contains(aspect) ? "checkmark.circle.fill" : "circle")
                content.imageProperties.tintColor = definition.aspects.contains(aspect) ? AppColor.primary : AppColor.secondary
                cell.accessoryType = .detailButton
                cell.tintColor = AppColor.secondary
                cell.contentConfiguration = content
                return cell
            }

            return nil
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return DefinitionSection(rawValue: section)?.displayText
    }
}
