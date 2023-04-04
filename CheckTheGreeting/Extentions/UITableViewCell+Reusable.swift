//
//  UITableViewCell+Reusable.swift
//  CheckTheGreeting
//
//  Created by Tanya on 31.10.2022.
//

import UIKit

protocol Reusable { }

extension Reusable where Self: UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: Reusable { }
