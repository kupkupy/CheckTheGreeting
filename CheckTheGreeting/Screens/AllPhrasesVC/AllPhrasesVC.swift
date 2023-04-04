//
//  AllPhrasesVC.swift
//  CheckTheGreeting
//
//  Created by Tanya on 24.02.2023.
//

import UIKit
import CoreData

class AllPhrasesVC: UIViewController {
    
    var viewModel: AllPhrasesViewModel?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(AllPhrasesCell.self, forCellReuseIdentifier: AllPhrasesCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = CustomColors.darkGray
        tableView.separatorStyle = .singleLine
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupConstraints()
        createCustomNavigationBar()
    }
}

// MARK: - Extentions
extension AllPhrasesVC {
    private func createCustomNavigationBar() {
        navigationController?.navigationBar.tintColor = UIColor.white

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    private func setupConstraints() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
}

// MARK: - AllPhrasesCellDelegate
extension AllPhrasesVC: AllPhrasesCellDelegate {
    func didTapChangeButton(text: String?) {
        let alert = UIAlertController(title: "Изменение фразы", message: nil, preferredStyle: .alert)
        alert.addTextField()
        alert.textFields?.first?.text = text
        alert.addAction(UIAlertAction(title: "Сохранить", style: .default, handler: { [weak self] _ in
            
            guard let field = alert.textFields?.first,
                  let newPhrase = field.text,
                    !newPhrase.isEmpty else { return }
            
            self?.tableView.visibleCells.forEach { cell in
                guard let allPhrasesCell = cell as? AllPhrasesCell,
                        let indexPath = self?.tableView.indexPath(for: allPhrasesCell) else { return }
                
                if allPhrasesCell.getText() == text {
                    if let result = self?.viewModel?.phrases.contains(where: { $0 == newPhrase }),
                        !result {
                        self?.viewModel?.updatePhrase(num: indexPath.row, newPhrase: newPhrase)
                        ((self?.tableView.cellForRow(at: indexPath)) as! AllPhrasesCell).configureCell(newPhrase)
                    } else {
                        if let alert = self?.makeAlertWarning() {
                            self?.present(alert, animated: true)
                        }
                    }
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))

        present(alert, animated: true)
    }
    
    func didTapDeleteButton(text: String?) {
        tableView.visibleCells.forEach { cell in
            guard let allPhrasesCell = cell as? AllPhrasesCell,
                  let indexPath = tableView.indexPath(for: allPhrasesCell),
                    let _ = viewModel?.dictionary?.title else { return }
            
            if allPhrasesCell.getText() == text {
                viewModel?.deletePhrase(num: indexPath.row)
                
                tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.endUpdates()
                
                if viewModel?.phrases.count == 0 {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension AllPhrasesVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension AllPhrasesVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 1 }
        return viewModel.phrases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AllPhrasesCell.identifier, for: indexPath) as! AllPhrasesCell
        
        //игнорим и удаляем из очереди все действия с contentView, чтобы работали кнопки "изменить" и "удалить"
        cell.contentView.isUserInteractionEnabled = false
        
        cell.delegate = self
        
        let phrase = viewModel?.phrases[indexPath.row]
        
        cell.configureCell(phrase)
        return cell
    }
}

extension AllPhrasesVC: UIComponentsFactory {}

