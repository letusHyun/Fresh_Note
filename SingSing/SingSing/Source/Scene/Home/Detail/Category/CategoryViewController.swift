//
//  CategoryViewController.swift
//  SingSing
//
//  Created by SeokHyun on 2023/03/13.
//

import UIKit

class CategoryViewController: BaseViewController {
  
  // MARK: - Properties
  
  var dismissCompletion: ((String) -> Void)?
  
  private let dataSource = CategoryCell.dataSource
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "카테고리"
    label.font = .boldSystemFont(ofSize: 30)
    label.textColor = .black
    return label
  }()
  
  private lazy var tableView: UITableView = {
    let tv = UITableView()
    tv.delegate = self
    tv.dataSource = self
    tv.backgroundColor = .clear
    tv.register(cellType: CategoryCell.self)
    return tv
  }()
  
  // MARK: - Setup
  
  override func setupLayouts() {
    self.view.addSubview(self.titleLabel)
    self.view.addSubview(self.tableView)
  }
  
  override func setupConstraints() {
    self.titleLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalToSuperview().inset(30)
    }
    
    self.tableView.snp.makeConstraints {
      $0.top.equalTo(self.titleLabel.snp.bottom).offset(20)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  override func setupStyles() {
    super.setupStyles()
  }
}

// MARK: - UITableViewDelegate

extension CategoryViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50
  }
}

// MARK: - UITableViewDataSource

extension CategoryViewController: UITableViewDataSource {
  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    return self.dataSource.count
  }
  
  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(for: indexPath) as CategoryCell
    cell.configure(self.dataSource[indexPath.row])
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let selectedCell = tableView.cellForRow(at: indexPath) as? CategoryCell else { return }
    
    dismissCompletion?(selectedCell.titleLabel.text!)
    
    self.dismiss(animated: true)
  }
}
