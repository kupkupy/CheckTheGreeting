//
//  Phrases+CoreDataProperties.swift
//  CheckTheGreeting
//
//  Created by Tanya on 27.01.2023.
//
//

import Foundation
import CoreData


extension Phrases {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Phrases> {
        return NSFetchRequest<Phrases>(entityName: "Phrases")
    }

    @NSManaged public var phrase: String
    @NSManaged public var id: String
    @NSManaged public var dictionaryID: String
    @NSManaged public var dictionary: Dictionary

}

extension Phrases : Identifiable {

}
