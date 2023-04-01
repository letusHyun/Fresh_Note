//
//  HomeViewController.swift
//  SingSing
//
//  Created by SeokHyun on 2023/02/13.
//

// TODO: - :버튼 만들어서 선택 삭제 기능 구현
import CoreData
import UIKit

import SnapKit

final class HomeViewController: BaseViewController {
  
  // MARK: - Properties
  
  private var foodModels = [FoodModel]()
  private var foodModel: FoodModel?
  private lazy var notiButton: UIButton = {
    let button = UIButton(
      UIImage(systemName: "bell", weight: .light),
      hexImageColor: SSType.lv2.rawValue
    )
    button.addTarget(self, action: #selector(notiButtonDidTap), for: .touchUpInside)
    return button
  }()
  
  private lazy var notiButtonItem: UIBarButtonItem = {
    let buttonItem = UIBarButtonItem(customView: self.notiButton)
    return buttonItem
  }()
  
  private lazy var searchButton: UIButton = {
    let button = UIButton(
      UIImage(systemName: "magnifyingglass", weight: .light),
      hexImageColor: SSType.lv2.rawValue
    )
    button.addTarget(self, action: #selector(searchButtonDidTap), for: .touchUpInside)
    return button
  }()

  private lazy var searchButtonItem: UIBarButtonItem = {
    let buttonItem = UIBarButtonItem(customView: self.searchButton)
    return buttonItem
  }()
  
  private lazy var addButton: UIButton = {
    let button = UIButton(
      UIImage(systemName: "plus", weight: .light),
      hexImageColor: SSType.lv2.rawValue
    )
    button.addTarget(self, action: #selector(addButtonDidTap), for: .touchUpInside)
    return button
  }()

  lazy var addButtonItem: UIBarButtonItem = {
    let buttonItem = UIBarButtonItem(customView: self.addButton)
    return buttonItem
  }()
  
  private lazy var tableView: UITableView = {
    let tv = UITableView()
    tv.delegate = self
    tv.dataSource = self
    tv.register(cellType: FoodListCell.self)
    tv.backgroundColor = SSType.background.color
    tv.separatorStyle = UITableViewCell.SeparatorStyle.none
    return tv
  }()
  
  // MARK: - LifeCycles
  
  override func viewDidLoad() {
    super.viewDidLoad()
    fetchData()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    configureNavigation()
  }
  
  // MARK: - Setup
  
  override func setupLayouts() {
    self.view.addSubview(self.tableView)
  }
  
  override func setupConstraints() {
    self.tableView.snp.makeConstraints {
      $0.left.right.equalToSuperview()
      $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(10)
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
    }
  }
  
  // MARK: - Helpers
  
  private func fetchData() {
    let foods = PersistenceManager.shared.fetchFoods()

    for i in 0..<foods.count {
      let food = foods[i]
      self.foodModels.append(FoodModel(
        uuid: food.uuid,
        name: food.name,
        expirationDate: food.expirationDate,
        consumptionDate: food.consumptionDate,
        extraDescription: food.extraDescription,
        category: food.category,
        thumbnail: food.thumbnail
      ))
    }
  }
  
  private func configureNavigation() {
    self.navigationItem.title = "Fresh Note"
    
    let appearance = UINavigationBarAppearance()
    appearance.shadowColor = .clear
    appearance.backgroundColor = SSType.background.color
    appearance.titleTextAttributes = [
      .font: UIFont.systemFont(ofSize: 25, weight: .light),
      .foregroundColor: SSType.lv3.color,
    ]
    
    self.navigationController?.navigationBar.standardAppearance = appearance
    self.navigationController?.navigationBar.compactAppearance = appearance
    self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
    
    self.navigationItem.leftBarButtonItem = self.notiButtonItem
    self.navigationItem.setRightBarButtonItems([addButtonItem, searchButtonItem], animated: false)
  }
  
  // MARK: - Action
  
  @objc func notiButtonDidTap() {
    print("DEBUG: noti tapped")
  }
  
  @objc func searchButtonDidTap() {
    print("DEBUG: search tapped")
  }
  
  @objc func addButtonDidTap() {
    let detailVC = DetailViewController(detailState: .addition)
    detailVC.popCompletion = { [weak self] in
      let foods = PersistenceManager.shared.fetchFoods()
      guard let lastFood = foods.last else { return }
      
      self?.foodModels.append(FoodModel(
        uuid: lastFood.uuid,
        name: lastFood.name,
        expirationDate: lastFood.expirationDate,
        consumptionDate: lastFood.consumptionDate,
        extraDescription: lastFood.extraDescription,
        category: lastFood.category,
        thumbnail: lastFood.thumbnail
      ))
      
     self?.tableView.reloadData()
   }
    
    self.navigationController?.pushViewController(detailVC, animated: true)
  }
}

// MARK: - UITableViewDelegate

extension HomeViewController: UITableViewDelegate {
  
  func tableView(
    _ tableView: UITableView,
    heightForRowAt indexPath: IndexPath
  ) -> CGFloat {
    return 100
  }
}

// MARK: - UITableViewDataSource

extension HomeViewController: UITableViewDataSource {
  
  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(for: indexPath) as FoodListCell
    cell.configure(self.foodModels[indexPath.row])
    
    return cell
  }
  
  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    return self.foodModels.count
  }
  
  func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {
    let detailVC = DetailViewController(detailState: .editing)
    detailVC.foodModel = self.foodModels[indexPath.row]
    
    detailVC.popCompletion = { [weak self] in
      self?.foodModels = PersistenceManager.shared.fetchFoodModels()
      self?.foodModel = self?.foodModels[indexPath.row]
      
      self?.tableView.reloadData()
    }
    
    self.navigationController?.pushViewController(detailVC, animated: true)
  }
  
  func tableView(
    _ tableView: UITableView,
    commit editingStyle: UITableViewCell.EditingStyle,
    forRowAt indexPath: IndexPath
  ) {
    if editingStyle == .delete {
      foodModels.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .fade)
      PersistenceManager.shared.deleteFood(index: indexPath.row)
    }
  }
}
