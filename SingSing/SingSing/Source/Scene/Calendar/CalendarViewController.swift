//
//  CalendarViewController.swift
//  SingSing
//
//  Created by SeokHyun on 2023/02/15.
//

import UIKit

import FSCalendar
import SnapKit

class CalendarViewController: BaseViewController {
  
  // MARK: - Properties
  
  private lazy var calendar: FSCalendar = {
    let calendar = FSCalendar()
    calendar.locale = Locale(identifier: "ko_KR")
    calendar.backgroundColor = .clear
    calendar.appearance.titleDefaultColor = UIColor(hex: "716D6D")
    calendar.appearance.selectionColor = UIColor(hex: "716D6D", alpha: 0.15)
    calendar.appearance.todayColor = UIColor(hex: "FF0000", alpha: 0.15)
    calendar.appearance.headerDateFormat = "YYYY년 M월"
    calendar.appearance.headerTitleColor = SSType.lv3.color
    calendar.appearance.weekdayTextColor = UIColor(hex: "716D6D")
    calendar.placeholderType = .none
    
    calendar.calendarWeekdayView.weekdayLabels[0].textColor = .systemRed
//    calendar.appearance.titleWeekendColor = UIColor(hex: "FF0000")
//    calendar.appearance.headerTitleAlignment = .left

    calendar.scrollDirection = .vertical
    calendar.scrollEnabled = true
    
    calendar.delegate = self
    return calendar
  }()
  
  // MARK: - LifeCycle
  
  // MARK: - Setup
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func setupLayouts() {
    self.view.addSubview(self.calendar)
  }
  
  override func setupConstraints() {
    self.calendar.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.top.equalTo(self.view.safeAreaLayoutGuide).inset(40)
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(330)
    }
  }
  
  override func setupStyles() {
    super.setupStyles()
    
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
}
