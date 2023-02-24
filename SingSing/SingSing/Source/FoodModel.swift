//
//  FoodModel.swift
//  SingSing
//
//  Created by SeokHyun on 2023/02/18.
//

import Foundation

struct FoodModel {
  var uuid: UUID
  var name: String
  var expirationDate: String
  var consumptionDate: String?
  var extraDescription: String?
  var category = "미분류"
  var thumbnail: Data?
}
