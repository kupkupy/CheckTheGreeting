//
//  AllPhrasesView.swift
//  CheckTheGreeting
//
//  Created by Tanya on 24.02.2023.
//

import UIKit
import SnapKit

protocol AllPhrasesCellDelegate: AnyObject {
    func didTapChangeButton(text: String?)
    func didTapDeleteButton(text: String?)
}

class AllPhrasesCell: UITableViewCell {
    
    weak var delegate: AllPhrasesCellDelegate?
    
    //var cellIndexPath: IndexPath?
    
    private lazy var phraseLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont(name: "FuturaPT-Book", size: 24)
        label.numberOfLines = 0
        return label
    }()
    
//    private lazy var changeButton: UIButton = {
//        let button = UIButton()
//        button.backgroundColor = UIColor(hex: 0x3E4553)
//        button.setTitle("Изменить", for: .normal)
//        button.setTitleColor(.white, for: .normal)
//        button.layer.cornerRadius = 20
//        button.titleLabel?.font = UIFont(name: "FuturaPT-Medium", size: 16)
//        return button
//    }()
    
//    private lazy var deleteButton: UIButton = {
//        let button = UIButton()
//        button.backgroundColor = UIColor(hex: 0x3E4553)
//        button.setTitle("Удалить", for: .normal)
//        button.setTitleColor(.white, for: .normal)
//        button.layer.cornerRadius = 20
//        button.titleLabel?.font = UIFont(name: "FuturaPT-Medium", size: 16)
//        return button
//    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()
    
    lazy var changeButton = UIButton()
    lazy var deleteButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(phraseLabel)
        addSubview(buttonStackView)
        
        backgroundColor = CustomColors.darkGray
        
        addButtonsToStackView()
    }
    
    private func addButtonsToStackView() {
        let buttons = [changeButton, deleteButton]
        buttons.enumerated().forEach { (index, button) in
            button.layer.cornerRadius = 16
            button.backgroundColor = UIColor(hex: 0x3E4553)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = UIFont(name: "FuturaPT-Medium", size: 16)
            switch index {
            case 0:
                button.setTitle("Изменить", for: .normal)
                button.addTarget(self, action: #selector(changeButtonTapped(sender:)), for: .touchUpInside)
            case 1:
                button.setTitle("Удалить", for: .normal)
                button.addTarget(self, action: #selector(deleteButtonTapped(sender:)), for: .touchUpInside)
            default: break
            }
        }
        
        buttonStackView.addArrangedSubview(changeButton)
        buttonStackView.addArrangedSubview(deleteButton)
    }
    
    private func setupConstraints() {
        phraseLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(16)
            make.leading.equalTo(self.snp.leading).offset(16)
            make.trailing.equalTo(self.snp.trailing).offset(-16)
            make.bottom.equalTo(buttonStackView.snp.top).offset(-16)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(40)
            make.leading.equalTo(self.snp.leading).offset(16)
            make.bottom.equalTo(self.snp.bottom).offset(-8)
        }
    }
    
    func getText() -> String? {
        phraseLabel.text
    }
    
    func configureCell(_ text: String?) {
        phraseLabel.text = "\(text ?? "")"
    }
    
    @objc private func changeButtonTapped(sender: Any) {
        delegate?.didTapChangeButton(text: getText())
    }
    
    @objc private func deleteButtonTapped(sender: Any) {   
        delegate?.didTapDeleteButton(text: getText())
    }
}
