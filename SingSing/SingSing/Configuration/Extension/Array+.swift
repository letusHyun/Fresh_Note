//
//  Array+.swift
//  SingSing
//
//  Created by SeokHyun on 2023/02/20.
//

import Foundation

extension Array where Element: Hashable {
  mutating func removeDuplicates() {
    var addedDict = [Element : Bool]()
    self = filter({ value in
      addedDict.updateValue(true, forKey: value) == nil
    })
  }
}
