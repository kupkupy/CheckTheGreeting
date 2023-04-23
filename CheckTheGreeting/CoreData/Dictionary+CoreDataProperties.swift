//
//  Dictionary+CoreDataProperties.swift
//  CheckTheGreeting
//
//  Created by Tanya on 23.04.2023.
//
//

import Foundation
import CoreData


extension Dictionary {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Dictionary> {
        return NSFetchRequest<Dictionary>(entityName: "Dictionaries")
    }

    @NSManaged public var title: String?

}

extension Dictionary : Identifiable {

}
