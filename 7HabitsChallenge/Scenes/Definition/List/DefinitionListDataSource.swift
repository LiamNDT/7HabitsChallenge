//
//  DefinitionListDataSource.swift
//  7HabitsChallenge
//
//  Created by Bui V Chanh on 04/08/2021.
//

import CoreData
import UIKit

class DefinitionListDataSource: UITableViewDiffableDataSource<DefinitionListDataSource.Section, Definition> {
    static let reuseIdentifier = "DefinitionListCellReuseIdentifier"
    let entityNamed = "DefinitionLocal"

    enum Section {
        case main
    }

    init(tableView: UITableView) {
        super.init(tableView: tableView) { tableview, indexPath, definition in
            let cell = tableview.dequeueReusableCell(withIdentifier: Self.reuseIdentifier, for: indexPath)
            var content = cell.defaultContentConfiguration()
            content.text = definition.content
            cell.accessoryType = .disclosureIndicator
            cell.tintColor = AppColor.secondary
            cell.contentConfiguration = content

            return cell
        }
    }

    func fetchList(_ page: Int = 1, completion: @escaping ([Definition]) -> Void) {
        retrieve(completion: completion)
    }
}

extension DefinitionListDataSource {
    func save(_ model: Definition, completion: @escaping (Definition?) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: entityNamed, in: managedContext) else {
            return
        }

        let definition = NSManagedObject(entity: entity, insertInto: managedContext)
        definition.setValue(model.id, forKey: "id")
        definition.setValue(model.content, forKey: "content")
        definition.setValue(model.aspects.map { "\($0)" }.joined(separator: ";"), forKey: "aspects")
        definition.setValue(Date().toMillis(), forKey: "uTimestamp")

        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save \(error) , \(error.userInfo)")
            completion(nil)
        }
        completion(model)
    }

    func update(_ model: Definition, completion: @escaping (Definition?) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityNamed)
        fetchRequest.predicate = NSPredicate(format: "id = %@", model.id.uuidString)

        do {
            let result = try managedContext.fetch(fetchRequest)
            let definition = result[0] as! NSManagedObject
            definition.setValue(model.content, forKey: "content")
            definition.setValue(model.aspects.map { "\($0)" }.joined(separator: ";"), forKey: "aspects")
            definition.setValue(Date().toMillis(), forKey: "uTimestamp")

            try managedContext.save()

        } catch let error as NSError {
            print("Could not save \(error) , \(error.userInfo)")
            completion(nil)
        }
        completion(model)
    }

    func retrieve(completion: @escaping ([Definition]) -> Void) {
        var listOfModel = [Definition]()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            completion([])
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityNamed)

        do {
            let result = try managedContext.fetch(fetchRequest)

            var model: Definition
            for data in result as! [NSManagedObject] {
                model = Definition()
                model.id = data.value(forKey: "id") as! UUID
                model.content = data.value(forKey: "content") as! String
                let aspects = data.value(forKey: "aspects") as! String
                model.aspects = aspects.split(separator: ";").map { LifeThings.transform(String($0)) }

                listOfModel.append(model)
            }
        } catch {
            print("Fetch fail")
        }
        completion(listOfModel)
    }
}
