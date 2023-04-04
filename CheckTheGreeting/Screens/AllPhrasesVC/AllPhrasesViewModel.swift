//
//  AllPhrasesViewModel.swift
//  CheckTheGreeting
//
//  Created by Tanya on 28.02.2023.
//

import Foundation

class AllPhrasesViewModel {
    var dictionary: Dictionary?
    
    var phrases: [String] = []
    
    init(dictionary: Dictionary?) {
        self.dictionary = dictionary
        updateDictionaryData()
    }
    
    func deletePhrase(num: Int) {
        if let dictionaryName = dictionary?.title {
            let phraseText = phrases[num]
            CoreDataManager.shared.deletePhrase(phrase: phraseText, from: dictionaryName)
            phrases.remove(at: num)
        }
    }
    
    private func updateDictionaryData() {
        if let dictionary = dictionary?.title,
           let dictionaryItems = CoreDataManager.shared.fetchPhrases(dictionaryName: dictionary) {
            phrases = dictionaryItems.compactMap { $0.phrase }
        }
    }
    
    func updatePhrase(num: Int, newPhrase: String) {
        let phrase = phrases[num]
        
        if let dictionaryName = (dictionary?.title) {
            CoreDataManager.shared.update(phrase: phrase, newPhrase: newPhrase, dictionaryName: dictionaryName)
            phrases[num] = phrase
        }
    }
}
