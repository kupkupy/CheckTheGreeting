//
//  Factories.swift
//  CheckTheGreeting
//
//  Created by Tanya on 12.01.2023.
//

import UIKit

public protocol UIComponentsFactory {
    func makeButton(withText text: String) -> UIButton
    func makeAlertWarning() -> UIAlertController
}

extension UIComponentsFactory {
    func makeButton(withText text: String) -> UIButton {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 0.893, green: 0.275, blue: 0.207, alpha: 1)
        button.setTitle(text, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 20
        button.titleLabel?.font = UIFont(name: "FuturaPT-Medium", size: 20)
        
        //MARK: - gradient
        #warning("разобраться с layer")
        let gradientLayer = CAGradientLayer()
        let colorFirst = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1).cgColor
        let colorSecond = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1).cgColor

        gradientLayer.colors = [colorFirst, colorSecond]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)

        gradientLayer.frame = button.bounds
        gradientLayer.cornerRadius = button.layer.cornerRadius
        //button.layer.insertSublayer(gradientLayer, at: 0)
        
        // shadow
        button.layer.shadowOffset = .init(width: 0, height: 4)
        button.layer.shadowRadius = 6
        button.layer.shadowColor = UIColor(red: 0.893, green: 0.275, blue: 0.207, alpha: 1).cgColor
        button.layer.shadowOpacity = 0.4
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    func makeAlertWarning() -> UIAlertController {
        let alert = UIAlertController(title: "Упс!", message: "Такая фраза уже существует. Введите другое значение", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Назад", style: .cancel))
        return alert
    }
}

