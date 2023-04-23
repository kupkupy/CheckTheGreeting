//
//  NewDictionaryVC.swift
//  CheckTheGreeting
//
//  Created by Tanya on 24.12.2022.
//

import UIKit

//protocol NewDictionaryVCDelegate: AnyObject {
//    func update()
//}

class NewDictionaryVC: UIViewController {
    
    var newDictionaryView: NewDictionaryView { return self.view as! NewDictionaryView }
    var viewModel: NewDictionaryViewModel?
    
    //weak var delegate: NewDictionaryVCDelegate?

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newDictionaryView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        newDictionaryView.textField.becomeFirstResponder()
    }
    
    override func loadView() {
        self.view = NewDictionaryView(frame: UIScreen.main.bounds)
    }
}


//MARK: - Extention
extension NewDictionaryVC: ButtonActionDelegate, CloseButtonDelegate, UIComponentsFactory {
    func didTapButton() {
        guard let text = newDictionaryView.textField.text, !text.isEmpty else { return }
    
        if let result = viewModel?.fetchDictionaries()?.contains(where: { $0.title == text }), result {
            present(makeAlertWarning(), animated: true)
        } else {
            viewModel?.createDictionary(text: text)
            self.dismiss(animated: true)
        }
        
    }

    func didTapCloseButton() {
        self.dismiss(animated: true)
    }
}




