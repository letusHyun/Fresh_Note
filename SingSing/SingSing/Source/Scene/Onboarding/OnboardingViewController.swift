//
//  OnboardingViewController.swift
//  SingSing
//
//  Created by SeokHyun on 2023/02/28.
//

import Combine
import UIKit

import SnapKit

final class OnboardingViewController: BaseViewController {
  
  // MARK: - Properties
  
  private var cancellables = Set<AnyCancellable>()
  private let viewModel = OnboardingViewModel()
  private let input = PassthroughSubject<OnboardingViewModel.Input, Never>()
  
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
    
    cv.register(cellType: DescriptionCell.self)
    cv.register(cellType: DdayCell.self)
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
    bind()
  }
  
  // MARK: - Binding
  
  private func bind() {
    let output = self.viewModel.transform(input: self.input.eraseToAnyPublisher())
    
    output
      .receive(on: RunLoop.main)
      .sink { [weak self] event in
        switch event {
        case .keyboardDown:
          self?.view.endEditing(true)
          self?.dDayCell?.contentView.endEditing(true)
        case .saveCoreData:
          let tabBarVC = MainTabBarController()
          tabBarVC.modalPresentationStyle = .fullScreen
          self?.present(tabBarVC, animated: true)
          
        case .error(let err):
          print(err)
          
        case .passCellIndex(let index):
          self?.pageControl.currentPage = index //ui 변경
          let lastIndex = 2
          if self?.pageControl.currentPage == lastIndex {
            UIView.animate(withDuration: 0.5) { //ui 변경
              self?.startButton.isHidden = false
              self?.startButton.alpha = 1.0
              self?.view.layoutIfNeeded()
            }
          } else { //ui변경
            self?.startButton.alpha = 0.0
            self?.startButton.isHidden = true
          }
        }
        
        
      }
      .store(in: &self.cancellables)
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
    self.input.send(.touchsBegan)
  }
  
  // TODO: - OnboardingVC rootVC로 설정해서 메모리 누수 해결하기
  @objc private func startButtonDidTap() {
    self.input.send(.startButtonDidTap)
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
    self.input.send(.scrollViewDidEndDecelerating(scrollView))
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
      let descriptionCell = collectionView.dequeueReusableCell(for: indexPath) as DescriptionCell
      descriptionCell.configure(description: description)
      return descriptionCell
      
    case .dDay:
      let dDayCell = collectionView.dequeueReusableCell(for: indexPath) as DdayCell
      dDayCell.textFieldDidChange = { [weak self] isEmpty in
        if isEmpty {
          self?.startButton.backgroundColor = SSType.lv2.color.withAlphaComponent(0.5)
          self?.startButton.isEnabled = false
        } else {
          self?.startButton.backgroundColor = SSType.lv2.color
          self?.startButton.isEnabled = true
        }
      }
      
      return dDayCell
    }
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    guard let dDayCell = collectionView.cellForItem(at: indexPath) as? DdayCell
    else { return }
    
    self.dDayCell = dDayCell
    self.input.send(.didSelectItemAt(dDayCell))
  }
}
