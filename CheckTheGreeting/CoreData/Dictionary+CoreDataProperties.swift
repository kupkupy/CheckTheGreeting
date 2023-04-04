//
//  Dictionary+CoreDataProperties.swift
//  CheckTheGreeting
//
//  Created by Tanya on 22.01.2023.
//
//

import Foundation
import CoreData


extension Dictionary {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Dictionary> {
        return NSFetchRequest<Dictionary>(entityName: "Dictionaries")
    }

    @NSManaged public var title: String
    @NSManaged public var id: String
    @NSManaged public var phrases: NSSet?

}

// MARK: Generated accessors for phrases
extension Dictionary {

    @objc(addPhrasesObject:)
    @NSManaged public func addToPhrases(_ value: Phrases)

    @objc(removePhrasesObject:)
    @NSManaged public func removeFromPhrases(_ value: Phrases)

    @objc(addPhrases:)
    @NSManaged public func addToPhrases(_ values: NSSet)

    @objc(removePhrases:)
    @NSManaged public func removeFromPhrases(_ values: NSSet)

}

extension Dictionary : Identifiable {

}
