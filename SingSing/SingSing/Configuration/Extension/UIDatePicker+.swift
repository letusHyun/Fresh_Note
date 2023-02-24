//
//  UIDatePicker+.swift
//  SingSing
//
//  Created by SeokHyun on 2023/02/20.
//

import UIKit

extension UIDatePicker {
  func setupStyles() {
    self.datePickerMode = .date
    self.locale = Locale(identifier: "ko_KR")
    self.preferredDatePickerStyle = .wheels
  }
}
