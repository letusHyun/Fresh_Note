//
//  BaseViewController.swift
//  SingSing
//
//  Created by SeokHyun on 2023/02/13.
//

import UIKit

class BaseViewController: UIViewController {
  
  // MARK: - LifeCycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupLayouts()
    setupConstraints()
    setupStyles()
    bind()
  }
  
  // MARK: - Setup
  
  func setupLayouts() { }
  func setupConstraints() { }
  func setupStyles() {
    self.view.backgroundColor = SSType.background.color
  }
  
  // MARK: - Configure
  
  func bind() { }
}
