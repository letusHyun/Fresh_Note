//
//  DdayCell.swift
//  SingSing
//
//  Created by SeokHyun on 2023/03/05.
//

import UIKit

import SnapKit

class DdayCell: UICollectionViewCell {
  
  // MARK: - Properties
  private let maxLength = 2
  static var id: String {
    return NSStringFromClass(Self.self).components(separatedBy: ".").last!
  }
  
  private let dLabel: UILabel = {
    let label = UILabel()
    label.text = "D - "
    let attrString = NSMutableAttributedString(string: label.text!)
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = 10
    attrString.addAttribute(
      .paragraphStyle,
      value: paragraphStyle,
      range: NSMakeRange(0, attrString.length)
    )
    label.attributedText = attrString
    
    label.numberOfLines = 3
    label.font = .systemFont(ofSize: 50)
    label.textColor = SSType.lv3.color
    label.textAlignment = .center
    return label
  }()
  
  private lazy var textField: UITextField = {
    let tf = UITextField()
    tf.placeholder = "Day"
    tf.keyboardType = .numberPad
    tf.font = .systemFont(ofSize: 50)
    tf.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
    tf.textColor = SSType.lv3.color
    return tf
  }()
  // MARK: - LifeCycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupLayouts()
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Configure
  
  func configure(day: String) {
    //날짜 주입
  }
  
  // MARK: - Setup
  
  private func setupLayouts() {
    self.contentView.addSubview(self.dLabel)
    self.contentView.addSubview(self.textField)
  }
  
  private func setupConstraints() {
    self.dLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview().offset(-30)
      $0.centerY.equalToSuperview()
    }
    
    self.textField.snp.makeConstraints {
      $0.leading.equalTo(self.dLabel.snp.trailing)
      $0.trailing.equalToSuperview()
      $0.centerY.equalTo(self.dLabel)
    }
  }
  
  // MARK: - Action
  
  @objc func textDidChange(_ sender: UITextField) {
    if sender.text?.count ?? 0 > maxLength {
      sender.deleteBackward()
    }
  }
}
