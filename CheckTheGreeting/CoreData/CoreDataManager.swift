//
//  CoreDataManager.swift
//  CheckTheGreeting
//
//  Created by Tanya on 24.11.2022.
//

import UIKit
import CoreData

//protocol CoreDataManagedProtocol {
//    var persistentContainer: NSPersistentContainer { get }
//
//    func createDictionary(title: String) -> Dictionary?
//    func fetchDictionaries() -> [Dictionary]?
//    func fetchDictionary(with title: String) -> Dictionary?
//    func updateDictionary(dictionary: Dictionary, newTitle: String)
//    func deleteDictionary(dictionary: Dictionary)
//}

struct CoreDataManager {
    
    static let shared = CoreDataManager()
    private init() {}
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DictionaryDB")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Loading of store failed \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    private let dictionaryFetchRequest = NSFetchRequest<Dictionary>(entityName: "Dictionaries")
    private let phraseFetchRequest = NSFetchRequest<Phrases>(entityName: "Phrases")
    
    
    //MARK: - dictionaries actions
    @discardableResult //Этот атрибут применяется к объявлению функции или метода для подавления предупреждения компилятора, когда функция или методы, возвращающие значение, вызываются без дальнейшего использования их результата.
    func createDictionary(title: String) -> Dictionary? {
        let context = persistentContainer.viewContext
        
        let dictionary = NSEntityDescription.insertNewObject(forEntityName: "Dictionaries", into: context) as! Dictionary // NSManagedObject
        dictionary.title = title
        
        do {
            try context.save()
            return dictionary
        } catch let createError {
            print("Failed to create: \(createError)")
        }
        
        return nil
    }
    
    func fetchDictionaries() -> [Dictionary]? {
        let context = persistentContainer.viewContext
        
        do {
            let dictionaries = try context.fetch(dictionaryFetchRequest)
            return dictionaries
        } catch let fetchError {
            print("Failed to fetch companies: \(fetchError)")
        }
        
        return nil
    }
    
    func fetchDictionary(with title: String) -> Dictionary? {
        let context = persistentContainer.viewContext
        
        dictionaryFetchRequest.fetchLimit = 1
        dictionaryFetchRequest.predicate = NSPredicate(format: "title = %@", title)
        
        do {
            let dictionaries = try context.fetch(dictionaryFetchRequest)
            return dictionaries.first
        } catch let fetchError {
            print("Failed to fetch: \(fetchError)")
        }
        
        return nil
    }
    
    func updateDictionary(dictionary: Dictionary?, newTitle: String) {
        let context = persistentContainer.viewContext
        dictionary?.title = newTitle
        
        do {
            try context.save()
        } catch let createError {
            print("Failed to update: \(createError)")
        }
    }
    
    func deleteDictionary(dictionary: Dictionary) {
        let context = persistentContainer.viewContext
        context.delete(dictionary)
        
        if let dictionaryName = dictionary.title {
            deleteAllPhrases(from: dictionaryName)
        }
        
        do {
            try context.save()
        } catch let saveError {
            print("Failed to delete: \(saveError)")
        }
    }
    
    
    //MARK: - phrase actions
    
    func addPhrase(dictionary: String, text: String) -> Phrases? {
        let context = persistentContainer.viewContext
        
        let phrase = NSEntityDescription.insertNewObject(forEntityName: "Phrases", into: context) as! Phrases // NSManagedObject
        phrase.phrase = text
        phrase.dictionary = dictionary
        
        do {
            try context.save()
            return phrase
        } catch let createError {
            print("Failed to create: \(createError)")
        }
        
        return nil
    }

    func fetchPhrases(dictionaryName: String) -> [Phrases]? {
        let context = persistentContainer.viewContext

        do {
            phraseFetchRequest.predicate = NSPredicate(format: "dictionary == %@", dictionaryName)
            let phrases = try context.fetch(phraseFetchRequest)
            return phrases
        } catch let fetchError {
            print("Failed to fetch companies: \(fetchError)")
        }

        return nil
    }
    
    func update(phrase: String, newPhrase: String?, dictionaryName: String) {
        let context = persistentContainer.viewContext
        
        do {
            phraseFetchRequest.predicate = NSPredicate(format: "dictionary == %@", dictionaryName)
            let fetchedResults = try context.fetch(phraseFetchRequest)
            
            for entity in fetchedResults {
                if entity.phrase == phrase {
                    entity.phrase = newPhrase
                }
            }
            
            try context.save()
        } catch let createError {
            print("Failed to update: \(createError)")
        }
    }
    
    func deletePhrase(phrase: String, from dictionaryName: String) {
        let context = persistentContainer.viewContext

        do {
            phraseFetchRequest.predicate = NSPredicate(format: "dictionary == %@", dictionaryName)
            let fetchedResults = try context.fetch(phraseFetchRequest)
            
            for entity in fetchedResults {
                if entity.phrase == phrase {
                    context.delete(entity)
                }
            }
            
            try context.save()
        } catch let saveError {
            print("Failed to delete: \(saveError)")
        }
    }
    
    private func deleteAllPhrases(from dictionaryName: String) {
        let context = persistentContainer.viewContext
        
        do {
            phraseFetchRequest.predicate = NSPredicate(format: "dictionary == %@", dictionaryName)
            let fetchedResults = try context.fetch(phraseFetchRequest)
            
            for entity in fetchedResults {
                context.delete(entity)
            }
            
        } catch {
            print("Failed to delete: \(error)")
        }
    }

    
    // MARK: - Save Context
    func saveContext() {
        if persistentContainer.viewContext.hasChanges {
            do {
                try persistentContainer.viewContext.save()
            } catch {
                print("An error occurred while saving: \(error)")
            }
        }
    }
}
