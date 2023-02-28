//
//  UnderLineTextField.swift
//  SingSing
//
//  Created by SeokHyun on 2023/02/16.
//

import UIKit

import SnapKit

final class UnderlineTextField: UITextField {
  
  // MARK: - Properties
  
  private let underlineView: UIView = {
    let view = UIView()
    view.backgroundColor = SSType.lv1.color
    return view
  }()
  
  // MARK: - LifeCycle
  
  init(placeholder: String) {
    super.init(frame: .zero)
    setupLayouts()
    setupConstraints()
    setupStyles(placeholder: placeholder)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Setup
  
  private func setupLayouts() {
    self.addSubview(self.underlineView)
  }
  
  private func setupConstraints() {
    self.underlineView.snp.makeConstraints {
      $0.top.equalTo(self.snp.bottom)
      $0.left.right.equalToSuperview()
      $0.height.equalTo(1)
    }
  }
  
  private func setupStyles(placeholder: String) {
    self.font = .systemFont(ofSize: 15)
    self.textColor = .black
    self.clearButtonMode = .whileEditing
    let attr: [NSAttributedString.Key : Any] = [
      .foregroundColor : SSType.placeholder.color,
    ]
    let attrString = NSAttributedString(
      string: placeholder,
      attributes: attr
    )
    self.attributedPlaceholder = attrString
    
    addLeftPadding()
  }
  
  // MARK: - Helpers
  
  private func addLeftPadding(width: CGFloat = 5) {
    let paddingView = UIView(
      frame: CGRect(x: 0, y: 0, width: width, height: self.frame.height)
    )
    self.leftView = paddingView
    self.leftViewMode = .always
  }
}
