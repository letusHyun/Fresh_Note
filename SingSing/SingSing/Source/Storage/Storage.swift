//
//  Storage.swift
//  SingSing
//
//  Created by SeokHyun on 2023/03/02.
//

import Foundation

final class Storage {
  
  static func setFirstTime(dDay: String, time: Date) {
    if dDay.count == 2, //ex 03 -> 3
       dDay[dDay.startIndex] == "0" {
      var result = dDay
      result.remove(at: result.startIndex)
      UserDefaults.standard.set(result, forKey: UserDefaultsKey.dDay.rawValue)
    } else {
      UserDefaults.standard.set(dDay, forKey: UserDefaultsKey.dDay.rawValue)
    }
    
    UserDefaults.standard.set(time, forKey: UserDefaultsKey.time.rawValue)
    UserDefaults.standard.set("No", forKey: UserDefaultsKey.isFirstTime.rawValue)
  }
  
  static func isFirstTime() -> Bool {
    if UserDefaults.standard.object(forKey: UserDefaultsKey.isFirstTime.rawValue) == nil {
      return true
    } else { return false }
  }
}

extension Storage {
  private enum UserDefaultsKey: String {
    case dDay
    case isFirstTime
    case time
  }
}
