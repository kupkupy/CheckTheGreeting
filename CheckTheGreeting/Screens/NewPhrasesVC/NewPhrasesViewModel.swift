//
//  NewPhrasesViewModel.swift
//  CheckTheGreeting
//
//  Created by Tanya on 13.03.2023.
//

import Foundation

class NewPhrasesViewModel {
    let dictionary: Dictionary?
    
    //var phrases: [String]
    
    init(dictionary: Dictionary?) {
        self.dictionary = dictionary
        //self.phrases = phrases
    }
    
    func addPhraseToDictionary(text: String) {
        if let dictionary = dictionary?.title{
            CoreDataManager.shared.addPhrase(dictionary: dictionary, text: text)
        }
    }
}
