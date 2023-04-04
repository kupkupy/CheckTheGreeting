//
//  PhraseViewModel.swift
//  CheckTheGreeting
//
//  Created by Tanya on 26.01.2023.
//

import Foundation

class PhraseViewModel {
    let dictionary: Dictionary?
    
    var phrases: [String]
    
    init(dictionary: Dictionary?, phrases: [String]) {
        self.dictionary = dictionary
        self.phrases = phrases
    }
    
    func updateDictionary(newTitle: String) {
        CoreDataManager.shared.updateDictionary(dictionary:  dictionary, newTitle: newTitle)
        dictionary?.title = newTitle
    }
    
    func fetchDataToViewModel() {
        if let dictionary = dictionary?.title,
           let dictionaryItems = CoreDataManager.shared.fetchPhrases(dictionaryName: dictionary) {
            phrases = dictionaryItems.compactMap { $0.phrase }
        }
    }
    
    func deleteDictionary() {
        guard let dictionary = dictionary else { return }
        CoreDataManager.shared.deleteDictionary(dictionary: dictionary)
    }
}
