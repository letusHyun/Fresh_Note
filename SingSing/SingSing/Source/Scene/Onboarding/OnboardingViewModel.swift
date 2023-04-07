//
//  OnboardingViewModel.swift
//  SingSing
//
//  Created by SeokHyun on 2023/04/07.
//

import Combine
import UIKit

protocol ViewModelType {
  associatedtype Input
  associatedtype Output
  func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never>
}

class OnboardingViewModel: ViewModelType {
  
  enum Input {
    case touchsBegan
    case startButtonDidTap
    case scrollViewDidEndDecelerating(UIScrollView)
    case didSelectItemAt(DdayCell)
  }
  
  enum Output {
    case keyboardDown
    case saveCoreData
    case error(CellError)
    case passCellIndex(Int)

  }
  
  enum CellError: Error {
    case noCell
    case noDayString
    case noTime
  }
  
  weak var dDayCell: DdayCell?
  
  func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
    let task = input.map { [weak self] event -> OnboardingViewModel.Output in
      switch event {
        
      case .touchsBegan:
        return .keyboardDown
        
      case .startButtonDidTap:
        guard let dDayCell = self?.dDayCell else { return .error(.noCell) }
        guard let dDay = dDayCell.dDayString else { return .error(.noDayString) }
        guard let time = dDayCell.time else { return .error(.noTime) }
        Storage.setFirstTime(dDay: dDay, time: time)
        return .saveCoreData
        
      case .scrollViewDidEndDecelerating(let scrollView):
        let index = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        return .passCellIndex(index)
        
      case .didSelectItemAt(let dDayCell):
        self?.dDayCell = dDayCell
        return .keyboardDown
        
        
      }
    }
      .eraseToAnyPublisher()
    
    return task
  }
}
