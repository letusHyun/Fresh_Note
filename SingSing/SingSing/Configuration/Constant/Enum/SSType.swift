//
//  SSType.swift
//  SingSing
//
//  Created by SeokHyun on 2023/02/15.
//

import UIKit

enum SSType: String {
  case lv1 = "C5D1A2"
  case lv2 = "A7B462"
  case lv3 = "444C18"
  
  case placeholder = "#929292"
  case background = "FBF8F3"
  case backgroundLv2 = "F6F4ED"
  
  var color: UIColor {
    switch self {
    case .lv1: return UIColor(hex: rawValue)
    case .lv2: return UIColor(hex: rawValue)
    case .lv3: return UIColor(hex: rawValue)
    case .background: return UIColor(hex: rawValue)
    case .backgroundLv2: return UIColor(hex: rawValue)
    case .placeholder: return UIColor(hex: rawValue)
    }
  }
}
