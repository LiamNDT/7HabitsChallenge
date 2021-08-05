//
//  DefinitionLocal+CoreDataProperties.swift
//  7HabitsChallenge
//
//  Created by Bui V Chanh on 04/08/2021.
//
//

import Foundation
import CoreData


extension DefinitionLocal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DefinitionLocal> {
        return NSFetchRequest<DefinitionLocal>(entityName: "DefinitionLocal")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var content: String?
    @NSManaged public var aspects: String?
    @NSManaged public var uTimestamp: Int64

}

extension DefinitionLocal : Identifiable {

}
