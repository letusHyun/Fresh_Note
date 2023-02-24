//
//  UIResponder+.swift
//  SingSing
//
//  Created by SeokHyun on 2023/02/17.
//

import UIKit

extension UIResponder {
  private weak static var _currentFirstResponder: UIResponder? = nil
  
  public static var current: UIResponder? {
    UIResponder._currentFirstResponder = nil
    UIApplication.shared.sendAction(#selector(findFirstResponder(sender:)), to: nil, from: nil, for: nil)
    return UIResponder._currentFirstResponder
  }
  
  @objc internal func findFirstResponder(sender: AnyObject) {
    UIResponder._currentFirstResponder = self
  }
}
