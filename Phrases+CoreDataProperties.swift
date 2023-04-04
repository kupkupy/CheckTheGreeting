//
//  Phrases+CoreDataProperties.swift
//  CheckTheGreeting
//
//  Created by Tanya on 03.02.2023.
//
//

import Foundation
import CoreData


extension Phrases {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Phrases> {
        return NSFetchRequest<Phrases>(entityName: "Phrases")
    }

    @NSManaged public var dictionary: String?
    @NSManaged public var phrase: String?

}

extension Phrases : Identifiable {

}
