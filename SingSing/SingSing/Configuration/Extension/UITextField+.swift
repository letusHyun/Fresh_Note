//
//  UITextField+.swift
//  SingSing
//
//  Created by SeokHyun on 2023/03/06.
//

import UIKit

extension UITextField {
  func addLeftPadding(width: CGFloat = 5) {
    let paddingView = UIView(
      frame: CGRect(x: 0, y: 0, width: width, height: self.frame.height)
    )
    self.leftView = paddingView
    self.leftViewMode = .always
  }
}
