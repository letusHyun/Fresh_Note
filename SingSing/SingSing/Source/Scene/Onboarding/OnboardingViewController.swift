//
//  OnboardingViewController.swift
//  SingSing
//
//  Created by SeokHyun on 2023/02/28.
//

import UIKit

import SnapKit

final class OnboardingViewController: BaseViewController {
  
  // MARK: - Properties
  
  private var dDayCell: DdayCell?
  private var dataSource = OnboardingCellModel.onboardings
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 30)
    label.textColor = SSType.lv3.color
    
    let attrString = NSMutableAttributedString(string: "Fresh Note")
    attrString.addAttribute(
      .underlineStyle,
      value: 1,
      range: NSRange(location: 0, length: attrString.length)
    )
    label.attributedText = attrString
    return label
  }()
  
  private lazy var collectionView: UICollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .horizontal
    let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    cv.backgroundColor = .clear
    cv.isPagingEnabled = true
    cv.showsHorizontalScrollIndicator = false
    
    cv.register(DescriptionCell.self, forCellWithReuseIdentifier: DescriptionCell.id)
    cv.register(DdayCell.self, forCellWithReuseIdentifier: DdayCell.id)
    cv.delegate = self
    cv.dataSource = self
    return cv
  }()
  
  private let pageControl: UIPageControl = {
    let pc = UIPageControl()
    pc.numberOfPages = 3
    pc.currentPage = 0
    pc.currentPageIndicatorTintColor = .black
    pc.pageIndicatorTintColor = .systemGray3
    pc.isEnabled = false
    return pc
  }()
  
  private lazy var startButton: UIButton = {
    let button = UIButton()
    button.setTitle("시작하기", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.backgroundColor = SSType.lv2.color.withAlphaComponent(0.5)
    button.isEnabled = false
    button.layer.cornerRadius = 25
    button.isHidden = true
    button.addTarget(self, action: #selector(startButtonDidTap), for: .touchUpInside)
    return button
  }()
  
  // MARK: - LifeCycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  // MARK: - Setup
  
  override func setupLayouts() {
    self.view.addSubview(self.titleLabel)
    self.view.addSubview(self.collectionView)
    self.view.addSubview(self.pageControl)
    self.view.addSubview(self.startButton)
  }
  
  override func setupConstraints() {
    self.titleLabel.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide).inset(45)
      $0.centerX.equalToSuperview()
    }
    
    self.collectionView.snp.makeConstraints {
      $0.top.equalTo(self.titleLabel.snp.bottom).offset(25)
      $0.left.right.equalToSuperview()
      $0.height.equalTo(550)
    }
    
    self.pageControl.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(120)
    }
    
    self.startButton.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.bottom.equalToSuperview().inset(50)
      $0.width.equalTo(210)
      $0.height.equalTo(50)
    }
  }
  
  override func setupStyles() {
    super.setupStyles()
  }
  
  // MARK: - Action
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }
  
  // TODO: - d Day 데이터 영구 저장
  // TODO: - 다른 Cell 클릭 시 키보드 내리기
  @objc private func startButtonDidTap() {
    
    guard let dDayCell = self.dDayCell else { return }
    guard let string = dDayCell.dDayString else { return }
    Storage.setFirstTime(dDay: string)
    
    let tabBarVC = MainTabBarController()
    tabBarVC.modalPresentationStyle = .fullScreen
    self.present(tabBarVC, animated: true)
  }
}

// MARK: - UICollectionViewDelegate

extension OnboardingViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return collectionView.bounds.size
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    return .zero
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumInteritemSpacingForSectionAt section: Int
  ) -> CGFloat {
    return .zero
  }
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    let index = Int(scrollView.contentOffset.x / scrollView.bounds.width)
    self.pageControl.currentPage = index
    
    let lastIndex = 2
    if self.pageControl.currentPage == lastIndex {
      UIView.animate(withDuration: 0.5) {
        self.startButton.isHidden = false
        self.startButton.alpha = 1.0
        self.view.layoutIfNeeded()
      }
    } else {
      self.startButton.alpha = 0.0
      self.startButton.isHidden = true
    }
  }
}

// MARK: - UICollectionViewDataSource

extension OnboardingViewController: UICollectionViewDataSource {
  
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return self.dataSource.count
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let index = indexPath.item
    
    switch self.dataSource[index] {
      
    case let .description(description):
      guard let descriptionCell = collectionView.dequeueReusableCell(
        withReuseIdentifier: DescriptionCell.id,
        for: indexPath
      ) as? DescriptionCell else { return UICollectionViewCell() }
      
      descriptionCell.configure(description: description)
      return descriptionCell
      
    case .dDay:
      guard let dDayCell = collectionView.dequeueReusableCell(
        withReuseIdentifier: DdayCell.id,
        for: indexPath
      ) as? DdayCell else { return UICollectionViewCell() }
      return dDayCell
    }
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    guard let dDayCell = collectionView.cellForItem(at: indexPath) as? DdayCell
    else { return }
    
    dDayCell.pushCompletion = { [weak self] isEmpty in
      if isEmpty {
        self?.startButton.backgroundColor = SSType.lv2.color.withAlphaComponent(0.5)
        self?.startButton.isEnabled = false
      } else {
        self?.startButton.backgroundColor = SSType.lv2.color
        self?.startButton.isEnabled = true
      }
    }
    
    dDayCell.contentView.endEditing(true)
    
    self.dDayCell = dDayCell
  }
}
