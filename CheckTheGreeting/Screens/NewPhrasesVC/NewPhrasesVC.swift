//
//  NewPhrasesVC.swift
//  CheckTheGreeting
//
//  Created by Tanya on 20.01.2023.
//

import UIKit

protocol NewPhrasesVCDelegate: AnyObject {
    func updatePhrases()
}

class NewPhrasesVC: UIViewController {

    var newPhrasesView: NewPhrasesView { return self.view as! NewPhrasesView }
    var viewModel: NewPhrasesViewModel?
    var dictionary: Dictionary?
    
    weak var delegate: NewPhrasesVCDelegate?

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newPhrasesView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        newPhrasesView.textField.becomeFirstResponder()
    }
    
    override func loadView() {
        self.view = NewPhrasesView(frame: UIScreen.main.bounds)
    }
}

//MARK: - Extention
extension NewPhrasesVC: ButtonActionDelegate, CloseButtonDelegate {
    func didTapButton() {
        guard let text = newPhrasesView.textField.text,
                !text.isEmpty else { return }
        
        #warning("Типа защита от дубликатов?")
        if let result = ((delegate as? PhrasesVC)?.viewModel?.phrases.contains(where: { $0 == text })), result {
            present(makeAlertWarning(), animated: true)
        } else {
            viewModel?.addPhraseToDictionary(text: text)
            delegate?.updatePhrases()
            self.dismiss(animated: true)
        }
    }
    
    func didTapCloseButton() {
        self.dismiss(animated: true)
    }
}

extension NewPhrasesVC: UIComponentsFactory {}
