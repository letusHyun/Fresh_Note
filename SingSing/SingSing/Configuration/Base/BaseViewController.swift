//
//  BaseViewController.swift
//  SingSing
//
//  Created by SeokHyun on 2023/02/13.
//

import UIKit

class BaseViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    setupLayouts()
    setupConstraints()
    setupStyles()
    bind()
  }
  
  func setupLayouts() { }
  func setupConstraints() { }
  func setupStyles() {
    self.view.backgroundColor = SSType.background.color
  }
  
  func bind() { }
}
