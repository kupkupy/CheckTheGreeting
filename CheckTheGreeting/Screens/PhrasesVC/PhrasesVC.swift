//
//  PhrasesVC.swift
//  CheckTheGreeting
//
//  Created by Tanya on 09.01.2023.
//

import UIKit
import CoreData

class PhrasesVC: UIViewController {

    var phrasesView: PhrasesView { return self.view as! PhrasesView }

    var viewModel: PhraseViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        phrasesView.delegate = self

        createCustomNavigationBar()
        makeGestureRecognizer()
    }

    override func loadView() {
        self.view = PhrasesView(frame: UIScreen.main.bounds)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updatePhrases()
    }
}

// MARK: - NewPhrasesVCDelegate
extension PhrasesVC: NewPhrasesVCDelegate {
    func updatePhrases() {
        viewModel?.fetchDataToViewModel()
        updateUI()
    }
}

// MARK: - ButtonActionDelegate
extension PhrasesVC: ButtonActionDelegate {
    func didTapButton() {
        let newPhrasesVC = NewPhrasesVC()
        newPhrasesVC.viewModel = NewPhrasesViewModel(dictionary: viewModel?.dictionary)
        newPhrasesVC.delegate = self
        present(newPhrasesVC, animated: true)
    }
}

// MARK: - UIGestureRecognizerDelegate
extension PhrasesVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}

// MARK: - PhrasesVC Actions
extension PhrasesVC {
    
    // MARK: - Update UI
    private func updateUI() {
        if let data = viewModel?.phrases, data.isEmpty {
            phrasesView.phrasesLabel.text = "Нет добавленных фраз"
        } else {
            phrasesView.phrasesLabel.text = viewModel?.phrases.randomElement()
        }
    }
    
    // MARK: - Make gesture recognizer
    func makeGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(actionOnScreenTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func actionOnScreenTap() {

        guard let phrase = viewModel?.phrases.randomElement() else { return }
        let filtedStorage = viewModel?.phrases.filter { $0 != phrase }

        if phrase != phrasesView.phrasesLabel.text {
            phrasesView.phrasesLabel.text = phrase
        } else if filtedStorage?.count == 0 {
            phrasesView.phrasesLabel.text = phrase
        } else {
            let filtedElement = filtedStorage?.randomElement()
            phrasesView.phrasesLabel.text = filtedElement
        }
    }
    
    // MARK: - Create navigation bar
    private func createCustomNavigationBar() {
        // Back button color
        #warning("не поменялся цвет")
        navigationController?.navigationBar.tintColor = UIColor.white

        let item = UIBarButtonItem(image: UIImage(systemName: "pencil"), style: .plain, target: self, action: #selector(rightBarButtonTapped))
        navigationItem.setRightBarButton(item, animated: true)
    }

    // MARK: - rightBarButton Action
    @objc func rightBarButtonTapped() {
        let sheet = UIAlertController(title: viewModel?.dictionary?.title, message: nil, preferredStyle: .actionSheet)

        sheet.addAction(createChangeNameAction())
        sheet.addAction(createWatchPhrasesAction())
        sheet.addAction(createDeleteAction())
        sheet.addAction(UIAlertAction(title: "Назад", style: .cancel))

        present(sheet, animated: true)
    }
    
    // MARK: - UIAlertController Actions
    private func createChangeNameAction() -> UIAlertAction {
        let action = UIAlertAction(title: "Изменить имя", style: .default, handler: { [weak self] _ in
            let alert = UIAlertController(title: "Ввведите новое название", message: nil, preferredStyle: .alert)
            alert.addTextField()
            alert.textFields?.first?.text = self?.viewModel?.dictionary?.title
            alert.addAction(UIAlertAction(title: "Сохранить", style: .default, handler: { [weak self] _ in
                guard let field = alert.textFields?.first,
                        let newTitle = field.text,
                        !newTitle.isEmpty else { return }

                self?.viewModel?.updateDictionary(newTitle: newTitle)
                self?.title = newTitle
            }))
            alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))

            self?.present(alert, animated: true)
        })
                                   
        return action
    }
    
    private func createWatchPhrasesAction() -> UIAlertAction {
        let action = UIAlertAction(title: "Смотреть все фразы", style: .default, handler: { [weak self] _ in
        
            let allPhrasesVC = AllPhrasesVC()
            
            if let viewModel = self?.viewModel {
                if viewModel.phrases.isEmpty {
                    let alert = UIAlertController(title: "Словарь пока пуст", message: "Добавьте фразу и попробуйте снова", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Понятно", style: .default))
                    self?.present(alert, animated: true)
                } else {
                    let allPhrasesViewModel = AllPhrasesViewModel(dictionary: viewModel.dictionary)
                    allPhrasesVC.viewModel = allPhrasesViewModel
                }
            }
            
            self?.navigationController?.pushViewController(allPhrasesVC, animated: true)
        })
        
        return action
    }

    
    private func createDeleteAction() -> UIAlertAction {
        let action = UIAlertAction(title: "Удалить словарь", style: .destructive, handler: { [weak self] _ in
            let alert = UIAlertController(title: "Удалить словарь?", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Да", style: .destructive, handler: { [weak self] _ in
                self?.viewModel?.deleteDictionary()
                self?.navigationController?.popViewController(animated: true)
            }))
            alert.addAction(UIAlertAction(title: "Нет", style: .cancel))
            self?.present(alert, animated: true)
        })
        return action
    }

}



