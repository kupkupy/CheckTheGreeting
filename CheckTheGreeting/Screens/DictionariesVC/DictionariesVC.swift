//
//  ViewController.swift
//  CheckTheGreeting
//
//  Created by Ilya on 28.02.2022.
//

import UIKit
import CoreData
import SnapKit

#warning("как сделать сортировку ячеек таблицы по последнему добавленному словарю?")

class DictionariesVC: UIViewController {
    
    let viewContext = CoreDataManager.shared.persistentContainer.viewContext
    
    let headerView = DictionariesHeaderView()

    var fetchedResultController: NSFetchedResultsController<Dictionary>?

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(DictionariesCell.self, forCellReuseIdentifier: DictionariesCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = CustomColors.darkGray
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        return tableView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        loadSaveData()
    }
    
    // MARK: - View hierarchy
    func setupViews() {
        #warning("при скролле меняется цвет навбара")
        view.addSubview(tableView)
        
        headerView.delegate = self
        
        setupNavigationBar()
        setupConstraints()
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.backgroundColor = CustomColors.darkGray
        navigationController?.navigationBar.barStyle = .black
    }
    
    // MARK: - Constraints
    func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
    //MARK: - Не вынесенная из контроллера логика
    #warning("как вынести в сервис?")
    func loadSaveData() {
        if fetchedResultController == nil {
            //NSFetchRequest исп-ся в качестве запроса выборки данных из модели. Можно задать правила фильтрации и сортировки объектов на этапе извлечения их из БД.
            let request = NSFetchRequest<Dictionary>(entityName: "Dictionaries")
            let sort = NSSortDescriptor(key: "title", ascending: false)
            request.sortDescriptors = [sort]
            //request.fetchBatchSize = 20

            // если указать значение в sectionNameKeyPath в виде какого-либо атрибута сущности БД, то получим таблицу, где данные сгруппированы в секции по этому атрибуту.
            fetchedResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: viewContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchedResultController?.delegate = self

            do {
                try fetchedResultController?.performFetch()
                tableView.reloadData()
            } catch {
                print("Fetch failed")
            }
        }
    }
}

//MARK: - UITableView DataSource, Delegate

extension DictionariesVC: ButtonActionDelegate {
    
    func didTapButton() {
        let newDictionaryVC = NewDictionaryVC()
        newDictionaryVC.viewModel = NewDictionaryViewModel()
        present(newDictionaryVC, animated: true)
    }
}


extension DictionariesVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let dictionary = fetchedResultController?.object(at: indexPath)

        // Back button without title on the next screen
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        let phrasesVC = PhrasesVC()
        let phraseViewModel = PhraseViewModel(dictionary: dictionary, phrases: [])
        phrasesVC.viewModel = phraseViewModel
        phrasesVC.title = dictionary?.title

        navigationController?.pushViewController(phrasesVC, animated: true)
    }
}

extension DictionariesVC: UITableViewDataSource {
    #warning("каким образом лучше задать высоту ячейки?")
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        64
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultController?.sections else { return 0 }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DictionariesCell.identifier, for: indexPath) as! DictionariesCell
        let dictionary = fetchedResultController?.object(at: indexPath)
        cell.configureCell(dictionary?.title)
        #warning("accessoryType разобраться")
        cell.accessoryType = UITableViewCell.AccessoryType.none
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let dictionary = fetchedResultController?.object(at: indexPath) else { return }

        if editingStyle == .delete {
            tableView.beginUpdates()

            CoreDataManager.shared.deleteDictionary(dictionary: dictionary)
            tableView.deleteRows(at: [indexPath], with: .fade)

            tableView.endUpdates()
        }
    }
}

extension DictionariesVC: NSFetchedResultsControllerDelegate {
    #warning("как отобразить свое название секции?")
    func numberOfSections(in tableView: UITableView) -> Int {
        fetchedResultController?.sections?.count ?? 0
    }

    // метод оповещает делегат о начале изменения объектов по запросу, с которым работает наш контроллер
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    // метод отлавливается делегатом, когда просходит обновление данных в модели; старый индекс до изменений объекта anObject - это indexPath, новый - newIndexPath, который объект получил после изменений.
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        default:
            break
        }
    }

    // метод оповещает делегат о конце изменений.
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}


