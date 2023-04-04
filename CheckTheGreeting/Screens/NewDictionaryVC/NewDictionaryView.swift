//
//  NewDictionaryView.swift
//  CheckTheGreeting
//
//  Created by Tanya on 25.12.2022.
//

import UIKit
import SnapKit

class NewDictionaryView: UIView {
    
    weak var delegate: (ButtonActionDelegate & CloseButtonDelegate)?
    weak var textFieldDelegate: UITextFieldDelegate?
    
    // MARK: - Subviews
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = CustomColors.darkGray
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Новый словарь"
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.textColor = .systemGray4
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = CustomColors.darkGray
        
#warning("размер шрифта плэйсхолдера не изменился")
        textField.attributedPlaceholder = NSAttributedString(string: "Название", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray4, NSAttributedString.Key.font: UIFont(name: "FuturaPT-Book", size: 24), NSAttributedString.Key.kern: -0.5])
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .yes
        textField.tintColor = .yellow
        textField.textColor = .white
        textField.font = .systemFont(ofSize: 24)
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.returnKeyType = .go
        textField.delegate = textFieldDelegate
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var createDictionaryButton: UIButton = {
        let button = makeButton(withText: "Создать")
        button.addTarget(self, action: #selector(creatDictionaryAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        let configuration = UIImage.SymbolConfiguration(pointSize: 30, weight: .light, scale: .default)
        button.setImage(UIImage(systemName: "xmark", withConfiguration: configuration), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(buttonCloseAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Override
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = CustomColors.darkGray
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View hierarchy
    private func setupViews() {
        addSubview(contentView)
        contentView.addSubview(label)
        contentView.addSubview(textField)
        contentView.addSubview(createDictionaryButton)
        contentView.addSubview(closeButton)
    }
    
    // MARK: - Setup
    private func setupConstraints() {
        contentView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self)
            make.bottom.equalTo(keyboardLayoutGuide.snp.top).offset(-16)
        }
        
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(32)
            make.trailing.equalTo(contentView.snp.trailing).offset(-32)
        }

        label.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).offset(32)
            make.bottom.equalTo(textField.snp.top).offset(-16)
        }

        textField.snp.makeConstraints { make in
            make.trailing.equalTo(createDictionaryButton.snp.leading).offset(-32)
            make.leading.equalTo(contentView.snp.leading)
            make.bottom.equalTo(contentView.snp.bottom)
            make.height.equalTo(56)
        }

        createDictionaryButton.snp.makeConstraints { make in
            make.trailing.equalTo(contentView.snp.trailing).offset(-32)
            make.bottom.equalTo(contentView.snp.bottom)
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
        
    }
    
    @objc func creatDictionaryAction() {
        delegate?.didTapButton()
    }
    
    @objc func buttonCloseAction() {
        delegate?.didTapCloseButton()
    }
}

extension NewDictionaryView: UIComponentsFactory { }

