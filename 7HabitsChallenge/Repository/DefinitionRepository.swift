//
//  DefinitionRepository.swift
//  7HabitsChallenge
//
//  Created by Bui V Chanh on 05/08/2021.
//

import CoreData
import Foundation
import UIKit

class DefinitionRepository {
    let entityNamed = "DefinitionLocal"

    func save(_ model: ManifestoViewModel.ManifestoItem, completion: @escaping (ManifestoViewModel.ManifestoItem?) -> Void) {
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

    func update(_ model: ManifestoViewModel.ManifestoItem, completion: @escaping (ManifestoViewModel.ManifestoItem?) -> Void) {
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

    func retrieve(completion: @escaping ([ManifestoViewModel.ManifestoItem]) -> Void) {
        var listOfModel = [ManifestoViewModel.ManifestoItem]()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            completion([])
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityNamed)

        do {
            let result = try managedContext.fetch(fetchRequest)

            var model: ManifestoViewModel.ManifestoItem
            for data in result as! [NSManagedObject] {
                model = ManifestoViewModel.ManifestoItem(id: data.value(forKey: "id") as! UUID,
                                                         content: data.value(forKey: "content") as! String,
                                                         aspects: [])
//                model.id = data.value(forKey: "id") as! UUID
//                model.content = data.value(forKey: "content") as! String
                let aspects = data.value(forKey: "aspects") as! String
                model.aspects = aspects.split(separator: ";").map { LifeThings.transform(String($0)) }

                listOfModel.append(model)
            }
        } catch {
            print("Fetch fail")
        }
        completion(listOfModel)
    }

    func delete(_ model: ManifestoViewModel.ManifestoItem, completion: @escaping (ManifestoViewModel.ManifestoItem?) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityNamed)
        fetchRequest.predicate = NSPredicate(format: "id = %@", model.id.uuidString)

        do {
            let result = try managedContext.fetch(fetchRequest)
            let definition = result[0] as! NSManagedObject
            managedContext.delete(definition)

            try managedContext.save()

        } catch let error as NSError {
            print("Could not save \(error) , \(error.userInfo)")
            completion(nil)
        }
        completion(model)
    }
}
