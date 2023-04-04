//
//  PhrasesView.swift
//  CheckTheGreeting
//
//  Created by Tanya on 13.01.2023.
//

import UIKit
import SnapKit

class PhrasesView: UIView {
    
    weak var delegate: ButtonActionDelegate?
    
    lazy var phrasesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "FuturaPT-Medium", size: 32)
        label.text = "Нет добавленных фраз"
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var addButton: UIButton = {
        let button = makeButton(withText: "+ Фраза")
        button.addTarget(self, action: #selector(addButtonAction), for: .touchUpInside)
        return button
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
    
    // MARK: - View hierarchy
    func setupViews() {
        addSubview(phrasesLabel)
        addSubview(addButton)
    }
    
    // MARK: - Constraints
    func setupConstraints() {
        phrasesLabel.snp.makeConstraints { make in
            make.center.equalTo(snp.center)
            make.leading.equalTo(snp.leading).offset(32)
            make.trailing.equalTo(snp.trailing).offset(-32)
        }
        
        addButton.snp.makeConstraints { make in
            make.trailing.equalTo(snp.trailing).offset(-32)
            make.bottom.equalTo(snp.bottom).offset(-64)
            make.height.equalTo(50)
            make.width.equalTo(100)
        }
    }
    
    // MARK: - Actions
    @objc func addButtonAction() {
        delegate?.didTapButton()
    }
}

extension PhrasesView: UIComponentsFactory { }
