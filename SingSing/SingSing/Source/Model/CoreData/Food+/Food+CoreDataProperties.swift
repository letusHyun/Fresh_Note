//
//  Food+CoreDataProperties.swift
//  SingSing
//
//  Created by SeokHyun on 2023/02/21.
//
//

import CoreData
import Foundation

extension Food {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<Food> {
    return NSFetchRequest<Food>(entityName: "Food")
  }
  
  @NSManaged public var uuid: UUID
  @NSManaged public var name: String
  @NSManaged public var expirationDate: String
  @NSManaged public var category: String
  @NSManaged public var extraDescription: String?
  @NSManaged public var consumptionDate: String?
  @NSManaged public var thumbnail: Data?
}

extension Food : Identifiable {
  
}
