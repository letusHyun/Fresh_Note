//
//  UIButton+.swift
//  SingSing
//
//  Created by SeokHyun on 2023/02/14.
//

import UIKit

extension UIButton {
  convenience init(_ image: UIImage?, hexImageColor hex: String) {
    self.init(type: .custom)
    
    self.contentVerticalAlignment = .fill
    self.contentHorizontalAlignment = .fill
    self.setImage(image, for: .normal)
    self.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
    self.tintColor = UIColor(hex: hex)
  }
}
