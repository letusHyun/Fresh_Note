//
//  DescriptionCell.swift
//  SingSing
//
//  Created by SeokHyun on 2023/03/01.
//

import UIKit

final class DescriptionCell: UICollectionViewCell {
  
  // MARK: - Properties
  
  static var id: String {
    return NSStringFromClass(Self.self).components(separatedBy: ".").last!
  }
  
  private let descriptionLabel: UILabel = {
    let label = UILabel()
    return label
  }()
  
  private var dDayTextField: UITextField?
  
  // MARK: - LifeCycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupLayouts()
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Setup
  
  private func setupLayouts() {
    self.contentView.addSubview(self.descriptionLabel)
  }
  
  private func setupConstraints() {
    self.descriptionLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.centerY.equalToSuperview()
    }
  }
  
  // MARK: - Configure
  
  func configure(description: String) {
    self.descriptionLabel.text = description
    configureStyles()
  }
  
  // MARK: - Helpers
  
  private func configureStyles() {
    guard let text = self.descriptionLabel.text else { return }
    let attrString = NSMutableAttributedString(string: text)
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = 10
    attrString.addAttribute(
      .paragraphStyle,
      value: paragraphStyle,
      range: NSMakeRange(0, attrString.length)
    )
    self.descriptionLabel.attributedText = attrString
    
    self.descriptionLabel.numberOfLines = 3
    self.descriptionLabel.font = .systemFont(ofSize: 16)
    self.descriptionLabel.textColor = SSType.lv3.color
    self.descriptionLabel.textAlignment = .center
  }
}
