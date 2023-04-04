//
//  DictionaryChecklistCell.swift
//  CheckTheGreeting
//
//  Created by Tanya on 31.10.2022.
//

import UIKit
import SnapKit

class DictionariesCell: UITableViewCell {
    
    private var cardView: UIView!
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "FuturaPT-Book", size: 18)
        label.textColor = .white
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = CustomColors.lightGray
        setupCardView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupCardView() {
        backgroundColor = .clear
        
        // убирает выделение ячейки
        selectionStyle = .none
        
        let cardView = UIView()
        cardView.backgroundColor = CustomColors.lightGray
        cardView.layer.cornerRadius = 20
        self.cardView = cardView
    }
    
    func setupConstraints() {
        contentView.addSubview(cardView)
        cardView.addSubview(titleLabel)
        
        cardView.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(16)
            make.leading.equalTo(self.snp.leading).offset(16)
            make.trailing.equalTo(self.snp.trailing).offset(-16)
            make.bottom.equalTo(self.snp.bottom)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(cardView.snp.top)
            make.leading.equalTo(cardView.snp.leading).offset(16)
            make.trailing.equalTo(cardView.snp.trailing).offset(-16)
            make.bottom.equalTo(cardView.snp.bottom)
        }
    }
    
    func configureCell(_ title: String?) {
        titleLabel.text = "\(title ?? "")"
    }
}
