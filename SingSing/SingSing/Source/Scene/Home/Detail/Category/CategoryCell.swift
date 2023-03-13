//
//  CategoryCell.swift
//  SingSing
//
//  Created by SeokHyun on 2023/03/13.
//

import UIKit

import Reusable
import SnapKit

class CategoryCell: UITableViewCell, Reusable {
  
  // MARK: - Properties
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 17)
    label.textColor = .black
    return label
  }()
  
  // MARK: - LifeCycle
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.setupLayouts()
    self.setupConstraints()
    self.setupStyles()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Setup
  
  private func setupLayouts() {
    self.contentView.addSubview(self.titleLabel)
  }
  
  private func setupConstraints() {
    
    self.titleLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().inset(10)
      $0.centerY.equalToSuperview()
    }
  }
  
  private func setupStyles() {
    contentView.backgroundColor = .clear
  }
  
  // MARK: - Configure
  
  func configure(_ title: String) {
    self.titleLabel.text = title
  }
}

extension CategoryCell {
  static let dataSource = [
    "과일",
    "채소",
    "정육/계란",
    "수산/건어물",
    "쌀/잡곡",
    "견과",
    "반찬/간편식",
    "건강",
    "면/통조림/가공식품",
    "샐러드/비건",
    "생수/음료",
    "치즈/유제품/스낵",
    "소스/잼/장류",
    "냉동식품/밀키트",
    "주류",
    "기타"
  ]
}
