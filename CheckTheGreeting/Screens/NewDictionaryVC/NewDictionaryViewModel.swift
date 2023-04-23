//
//  NewDictionaryViewModel.swift
//  CheckTheGreeting
//
//  Created by Tanya on 21.03.2023.
//

import Foundation

class NewDictionaryViewModel {
     
    func createDictionary(text: String) {
        CoreDataManager.shared.createDictionary(title: text)
    }
    
    func fetchDictionary(with title: String) -> Dictionary? {
        return CoreDataManager.shared.fetchDictionary(with: title)
    }
    
    func fetchDictionaries() -> [Dictionary]? {
        CoreDataManager.shared.fetchDictionaries()
    }
}
