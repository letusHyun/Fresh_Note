//
//  OnboardingCellType.swift
//  SingSing
//
//  Created by SeokHyun on 2023/03/05.
//

import Foundation

enum OnboardingCellType {
  case description(description: String)
  case dDay
}

struct OnboardingCellModel {
  static let onboardings: [OnboardingCellType] = [
    .description(description: """
    Fresh Note는 내가 입력한 유통 & 소비기한으로
    원하는 D - n 에 알림을 받을 수 있는
    알람 어플리케이션 입니다.
    """),
    
    .description(description: """
    유통 & 소비기한이 다가오기 전,
    식품을 더 오래, 안전하게 먹기 위해
    디데이 알람을 맞춰볼까요?
    """),
    
    .dDay
  ]
}
