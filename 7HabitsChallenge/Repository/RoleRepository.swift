//
//  RoleRepository.swift
//  7HabitsChallenge
//
//  Created by Bui V Chanh on 07/08/2021.
//

import CoreData
import Foundation
import UIKit

class RoleRepository {
    typealias VM = RoleViewModel
    let entityNamed = "RoleLocal"

    func save(_ model: VM.Item, completion: @escaping (VM.Item?) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: entityNamed, in: managedContext) else {
            return
        }

        let roleLocal = NSManagedObject(entity: entity, insertInto: managedContext)
        roleLocal.setValue(model.id, forKey: "id")
        roleLocal.setValue(model.content, forKey: "content")
        roleLocal.setValue(model.code, forKey: "code")
        roleLocal.setValue(model.name, forKey: "name")
        roleLocal.setValue(model.icon, forKey: "icon")
        roleLocal.setValue(Date().toMillis(), forKey: "uTimestamp")

        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save \(error) , \(error.userInfo)")
            completion(nil)
        }
        completion(model)
    }

    func saveAll(_ models: [VM.Item], completion: @escaping () -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: entityNamed, in: managedContext) else {
            return
        }
        do {
            for model in models {
                let roleLocal = NSManagedObject(entity: entity, insertInto: managedContext)
                roleLocal.setValue(model.id, forKey: "id")
                roleLocal.setValue(model.content, forKey: "content")
                roleLocal.setValue(model.code, forKey: "code")
                roleLocal.setValue(model.name, forKey: "name")
                roleLocal.setValue(model.icon, forKey: "icon")
                roleLocal.setValue(Date().toMillis(), forKey: "uTimestamp")

                try managedContext.save()
            }
        } catch let error as NSError {
            print("Could not save \(error) , \(error.userInfo)")
        }
    }

    func retrieve(completion: @escaping ([VM.Item]) -> Void) {
        var listOfModel = [VM.Item]()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            completion([])
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityNamed)

        do {
            let result = try managedContext.fetch(fetchRequest)

            var model: VM.Item
            for data in result as! [NSManagedObject] {
                model = VM.Item(id: data.value(forKey: "id") as! UUID,
                                code: data.value(forKey: "code") as! String,
                                name: data.value(forKey: "name") as! String,
                                content: data.value(forKey: "content") as! String,
                                icon: data.value(forKey: "icon") as! String)
                listOfModel.append(model)
            }
        } catch {
            print("Fetch fail")
        }
        completion(listOfModel)
    }

    func update(_ model: RoleViewModel.Item, completion: @escaping (RoleViewModel.Item?) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityNamed)
        fetchRequest.predicate = NSPredicate(format: "id = %@", model.id.uuidString)

        do {
            let result = try managedContext.fetch(fetchRequest)
            let role = result[0] as! NSManagedObject
            role.setValue(model.name, forKey: "name")
            role.setValue(model.content, forKey: "content")
            role.setValue(model.code, forKey: "code")
            role.setValue(Date().toMillis(), forKey: "uTimestamp")

            try managedContext.save()

        } catch let error as NSError {
            print("Could not save \(error) , \(error.userInfo)")
            completion(nil)
        }
        completion(model)
    }

    func delete(_ model: RoleViewModel.Item, completion: @escaping (RoleViewModel.Item?) -> Void) {
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
