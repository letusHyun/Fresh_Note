//
//  CalendarViewController.swift
//  SingSing
//
//  Created by SeokHyun on 2023/02/15.
//

import UIKit

import FSCalendar
import SnapKit

final class CalendarViewController: BaseViewController {
  
  // MARK: - Properties

  private lazy var collectionView: UICollectionView = {
    let cv = UICollectionView()
    
    return cv
  }()
  
  private lazy var calendar: FSCalendar = {
    let calendar = FSCalendar()
    calendar.locale = Locale(identifier: "ko_KR")
    calendar.backgroundColor = .clear
    
    calendar.appearance.titleDefaultColor = UIColor(hex: "716D6D")
    calendar.appearance.selectionColor = UIColor(hex: "716D6D", alpha: 0.15)
    calendar.appearance.todayColor = UIColor(hex: "FF0000", alpha: 0.15)
    calendar.appearance.weekdayTextColor = UIColor(hex: "716D6D")
    calendar.appearance.headerTitleAlignment = .left

    calendar.scrollEnabled = true
    calendar.placeholderType = .none
    calendar.headerHeight = 0
    calendar.delegate = self
    calendar.calendarWeekdayView.weekdayLabels[0].textColor = .systemRed
    
    //datePicker에서 날짜 선택 시, 해당 month로 이동
//    calendar.select(<#T##date: Date?##Date?#>, scrollToDate: true)
    return calendar
  }()

  //custom calendar
  
  private lazy var headerButton: UIButton = {
    let button = UIButton()
    button.setTitle(
      self.dateFormatter.string(from: self.calendar.currentPage),
      for: .normal
    )
    button.setTitleColor(SSType.lv3.color, for: .normal)
    button.addTarget(self, action: #selector(headerButtonDidTap), for: .touchUpInside)
    return button
  }()
  
  private lazy var dateFormatter: DateFormatter = {
    let df = DateFormatter()
    df.locale = Locale(identifier: "ko_KR")
    let headerPadding = "     "
    df.dateFormat = "\(headerPadding)yyyy년 M월"
    return df
  }()
  
  private lazy var toolBar: UIToolbar = {
    let toolBar = UIToolbar()
    toolBar.sizeToFit()
    
    let space = UIBarButtonItem(
      barButtonSystemItem: .flexibleSpace,
      target: nil,
      action: nil
    )
    let doneButton = UIBarButtonItem(
      barButtonSystemItem: .done,
      target: self,
      action: #selector(doneButtonDidTap)
    )
    toolBar.setItems([space, doneButton], animated: true)
    return toolBar
  }()
  
  // MARK: - LifeCycle
  
  override func viewDidLoad() {
    super.viewDidLoad()

  }
  
  // MARK: - Setup
  
  override func setupLayouts() {
    self.view.addSubview(self.headerButton)
    self.view.addSubview(self.calendar)
  }
  
  override func setupConstraints() {
    self.headerButton.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide).inset(20)
      $0.leading.equalToSuperview().inset(10)
      $0.bottom.equalTo(self.calendar.snp.top).offset(-20)
    }
    
    self.calendar.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(10)
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(330)
    }
  }
  
  override func setupStyles() {
    super.setupStyles()
    
  }
  
  // MARK: - Actions
  
  @objc func headerButtonDidTap() {
    print("DEBUG: headerButton Tapped")
    
  }
  
  @objc func doneButtonDidTap() {
    
  }
}

// MARK: - FSCalendarDelegateAppearance

extension CalendarViewController: FSCalendarDelegateAppearance {
  //토요일, 일요일 각각 Color 지정
  func calendar(
    _ calendar: FSCalendar,
    appearance: FSCalendarAppearance,
    titleDefaultColorFor date: Date
  ) -> UIColor? {
    let day = Calendar.current.component(.weekday, from: date) - 1

    if Calendar.current.shortWeekdaySymbols[day] == "토" {
      return UIColor(hex: "716D6D")
    } else if Calendar.current.shortWeekdaySymbols[day] == "일" {
      return UIColor.systemRed
    } else {
      return UIColor(hex: "716D6D")
    }
  }
}

// MARK: - FSCalendarDelegate

extension CalendarViewController: FSCalendarDelegate {
  func calendar(
    _ calendar: FSCalendar,
    didSelect date: Date,
    at monthPosition: FSCalendarMonthPosition
  ) {
    
  }
  
  func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
    self.headerButton.setTitle(
      self.dateFormatter.string(from: self.calendar.currentPage),
      for: .normal
    )
  }
}
