//
//  UIImage+.swift
//  SingSing
//
//  Created by SeokHyun on 2023/02/14.
//

import UIKit

extension UIImage {
  convenience init?(systemName: String, weight: UIImage.SymbolWeight) {
    let symbolConfig = UIImage.SymbolConfiguration(weight: weight)
    self.init(systemName: systemName, withConfiguration: symbolConfig)
    
    self.withRenderingMode(.alwaysTemplate)
  }

  func resizeImageTo(size: CGSize) -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
    self.draw(in: CGRect(origin: CGPoint.zero, size: size))
    let resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    
    return resizedImage
  }
}

