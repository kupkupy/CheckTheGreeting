//
//  DictionariesHeaderView.swift
//  CheckTheGreeting
//
//  Created by Tanya on 09.12.2022.
//

import UIKit
import SnapKit

class DictionariesHeaderView: UIView  {
    
    weak var delegate: ButtonActionDelegate?
    
    private lazy var greetingLabel: UILabel = {
        let label = UILabel()
        label.text = "Привет!"
        label.font = UIFont(name: "FuturaPT-Demi", size: 40)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
#warning("вместо текста-заглушки прокинуть данные")
    private lazy var statisticsLabel: UILabel = {
        let label = UILabel()
        label.text = "97 фраз, 7 словарей"
        label.font = UIFont(name: "FuturaPT-Book", size: 16)
        label.textColor = .systemGray4
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var addButton: UIButton = {
        let button = makeButton(withText: "+ Словарь")
        button.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        return button
        #warning("gradient")
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = CustomColors.darkGray
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(greetingLabel)
        addSubview(statisticsLabel)
        //addSubview(numberOfDictionariesLabel)
        addSubview(addButton)
    }
    
    func setupConstraints() {
        greetingLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(safeAreaLayoutGuide.snp.leading).offset(32)
            make.bottom.equalTo(statisticsLabel.snp.top).offset(-8)
        }
        
        statisticsLabel.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide.snp.leading).offset(32)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-16)
        }
        
//        numberOfDictionariesLabel.snp.makeConstraints { make in
//            make.leading.equalTo(safeAreaLayoutGuide.snp.leading).offset(32)
//            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-16)
//        }
        
        addButton.snp.makeConstraints { make in
            make.trailing.equalTo(safeAreaLayoutGuide.snp.trailing).offset(-32)
            make.bottom.equalTo(statisticsLabel.snp.bottom)
            make.width.equalTo(120)
            make.height.equalTo(50)
        }
    }
    
    // MARK: - Actions
    @objc func didTapAddButton() {
        delegate?.didTapButton()
    }
    
}

extension DictionariesHeaderView: UIComponentsFactory {}

