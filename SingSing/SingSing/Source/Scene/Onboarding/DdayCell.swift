//
//  DdayCell.swift
//  SingSing
//
//  Created by SeokHyun on 2023/03/05.
//

import UIKit

import SnapKit
import Reusable

class DdayCell: UICollectionViewCell, Reusable {
  
  // MARK: - Properties
  
  var textFieldDidChange: ((Bool) -> Void)?
  private let maxLength = 2
  
  private let descriptionLabel: UILabel = {
    let label = UILabel()
    label.text = "원하는 날짜와 알람 시간을 지정해주세요."
    label.textColor = SSType.lv3.color
    label.font = .systemFont(ofSize: 13)
    return label
  }()
  
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
  
  var dDayString: String?
  var time: Date?
  
  private lazy var textField: UITextField = {
    let tf = UITextField()
    tf.placeholder = "Day"
    tf.keyboardType = .numberPad
    tf.font = .systemFont(ofSize: 50)
    tf.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
    tf.textColor = SSType.lv3.color
    return tf
  }()
  
  private lazy var notiDatePicker: UIDatePicker = {
    let dp = UIDatePicker()
    dp.preferredDatePickerStyle = .compact
    dp.datePickerMode = .time
    dp.locale = Locale(identifier: "ko_KR")
    dp.addTarget(self, action: #selector(dateDidChange(_:)), for: .allEvents)
    return dp
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
    self.contentView.addSubview(self.notiDatePicker)
    self.contentView.addSubview(self.descriptionLabel)
  }
  
  private func setupConstraints() {
    self.descriptionLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.bottom.equalTo(self.dLabel.snp.top).offset(-50)
    }
    
    self.dLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview().offset(-25)
      $0.centerY.equalToSuperview()
    }
    
    self.textField.snp.makeConstraints {
      $0.leading.equalTo(self.dLabel.snp.trailing)
      $0.trailing.equalToSuperview()
      $0.centerY.equalTo(self.dLabel)
    }
    
    self.notiDatePicker.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(self.dLabel.snp.bottom).offset(40)
    }
  }
  
  // MARK: - Action
  
  @objc func textDidChange(_ sender: UITextField) {
    if sender.text?.count ?? 0 > self.maxLength {
      sender.deleteBackward()
    }
    
    if self.textField.text == "" ||
      self.textField.text == "00" {
      self.textFieldDidChange?(true)
    } else if self.textField.text == "0" {
      self.dDayString = self.textField.text
      self.textFieldDidChange?(false)
    } else {
      self.dDayString = self.textField.text
      self.textFieldDidChange?(false)
    }
  }
  
  @objc private func dateDidChange(_ sender: UIDatePicker) {
    self.time = sender.date
  }
}
