//
//  FoodListCell.swift
//  SingSing
//
//  Created by SeokHyun on 2023/02/13.
//

import UIKit

import SnapKit

final class FoodListCell: UITableViewCell {
  
  // MARK: - Properties
  
  static let id = "FoodListCell"
  
  private let defaultImage: UIImage = {
    guard let image = UIImage(systemName: "fork.knife.circle", weight: .medium)?
      .withTintColor(SSType.lv2.color)
    else { return UIImage() }
    return image
  }()
  
  private lazy var thumbnailImageView: UIImageView = {
    let iv = UIImageView()
    iv.backgroundColor = .clear
    iv.layer.borderColor = SSType.lv1.color.cgColor
    iv.layer.borderWidth = 2
    iv.layer.cornerRadius = 10
    iv.layer.masksToBounds = true
    iv.image = self.defaultImage
    iv.tintColor = SSType.lv2.color
    iv.backgroundColor = .clear
    return iv
  }()

  private let nameLabel: UILabel = {
    let label = UILabel()
    label.text = "제 품 명  : 우유"
    label.textColor = .black
    label.font = .systemFont(ofSize: 14)
    return label
  }()
  
  // TODO: - datePicker의 text add
  private let expirationDateLabel: UILabel = {
    let label = UILabel()
    label.textColor = .black
    label.font = .systemFont(ofSize: 14)
    return label
  }()
  
  private let categoryLabel: UILabel = {
    let label = UILabel()
    label.textColor = .black
    label.font = .systemFont(ofSize: 14)
    return label
  }()
  
  private let descriptionLabel: UILabel = {
    let label = UILabel()
    label.textColor = .black
    label.numberOfLines = 2
    label.font = .systemFont(ofSize: 14)
    return label
  }()
  
  private lazy var stackView: UIStackView = {
    let sv = UIStackView()
    [
      self.nameLabel,
      self.expirationDateLabel,
      self.categoryLabel,
      self.descriptionLabel
    ].forEach {
      sv.addArrangedSubview($0)
    }
    sv.backgroundColor = .clear
    sv.layer.cornerRadius = 4
    sv.layer.borderWidth = 1.5
    sv.layer.borderColor = SSType.lv1.color.cgColor
    sv.layoutMargins = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    sv.isLayoutMarginsRelativeArrangement = true
    
    sv.axis = .vertical
    sv.spacing = 0
    sv.distribution = .fillEqually
    return sv
  }()
  
  // MARK: - LifeCycle
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.contentView.backgroundColor = SSType.background.color
    setupLayouts()
    setupConstraints()
    setupStyles()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Setup
  
  private func setupLayouts() {
    self.contentView.addSubview(self.thumbnailImageView)
    self.contentView.addSubview(self.stackView)
  }
  
  private func setupConstraints() {
    self.thumbnailImageView.snp.makeConstraints {
      $0.width.equalTo(80)
      $0.height.equalTo(80)
      $0.left.equalToSuperview().inset(15)
      $0.centerY.equalToSuperview()
    }
    
    self.stackView.snp.makeConstraints {
      $0.left.equalTo(self.thumbnailImageView.snp.right).offset(10)
      $0.right.equalToSuperview().inset(10)
      $0.top.bottom.equalToSuperview().inset(5)
    }
  }
  
  private func setupStyles() {
    
  }
  
  // MARK: - Bind
  
  func configure(_ foodModel: FoodModel?) {
    guard let foodModel = foodModel else { return }
    self.nameLabel.text = "상품명: \(foodModel.name)"
    self.categoryLabel.text = "카테고리: \(foodModel.category)"
    self.expirationDateLabel.text = "유통기한: \(foodModel.expirationDate)"
    self.descriptionLabel.text = "메모: \(foodModel.extraDescription!)"
    
    if let data = foodModel.thumbnail {
      let image = UIImage(data: data)
      self.thumbnailImageView.image = image
    } else {
      self.thumbnailImageView.image = defaultImage.withRenderingMode(.alwaysTemplate)
    }
  }
}
