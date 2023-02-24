//
//  PersistenceManager.swift
//  SingSing
//
//  Created by SeokHyun on 2023/02/13.
//

import Foundation
import CoreData
class PersistenceManager {
  // MARK: - Properties
  static var shared: PersistenceManager = PersistenceManager()
  
  lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "SingSing") // xcdatamodeld 파일 이름
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()
  
  // 1. Context를 가져온다.
  //context를 이용해서 Managed Object를 생성, 저장, 관리, fetch 할 수 있음.
  var context: NSManagedObjectContext {
    return self.persistentContainer.viewContext
  }
  
  // MARK: - LifeCycle
  private init() { }

  // MARK: - Fetch
  func fetch<T: NSManagedObject>(request: NSFetchRequest<T>) -> [T] {
    do {
      let fetchResult = try self.context.fetch(request)
      return fetchResult
    } catch {
      print("DEBUG: \(error.localizedDescription)")
      return []
    }
  }
  
  // MARK: - Insert
  @discardableResult
  func insertItem(item: FoodModel) -> Bool {
    // 2. Entity를 가져온다
    let entity = NSEntityDescription.entity(forEntityName: "Food", in: self.context) // Food
    
    if let entity = entity {
      // 3. NSManagedObject를 만든다. (Entity로 형변환)
      let object = NSManagedObject(entity: entity, insertInto: self.context)

        // 4. NSManagedObject에 값을 세팅한다.
      object.setValue(item.name, forKey: "name")
      object.setValue(item.uuid, forKey: "uuid")
      object.setValue(item.expirationDate, forKey: "expirationDate")
      object.setValue(item.consumptionDate, forKey: "consumptionDate")
      object.setValue(item.extraDescription, forKey: "extraDescription")
      object.setValue(item.category, forKey: "category")
      object.setValue(item.thumbnail, forKey: "thumbnail")
      
      // 5. [최종] NSManagedObjectContext에 저장한다.
      do {
        try self.context.save()
        return true
      } catch {
        print("DEBUG: \(error.localizedDescription)")
        return false
      }
    } else {
      return false
    }
  }
  
  // MARK: - Delete
  @discardableResult
  func delete(object: NSManagedObject) -> Bool {
    self.context.delete(object)
    do {
      try context.save() // 5. NSManagedObjectContext에 저장한다.
      return true
    } catch {
      return false
    }
  }
  
  @discardableResult
  func deleteAll<T: NSManagedObject>(request: NSFetchRequest<T>) -> Bool {
    let request: NSFetchRequest<NSFetchRequestResult> = T.fetchRequest()
    let delete = NSBatchDeleteRequest(fetchRequest: request)
    do {
      try self.context.execute(delete)
      return true
    } catch {
      return false
    }
  }
  
  // MARK: - Count
  func count<T: NSManagedObject>(request: NSFetchRequest<T>) -> Int? {
    do {
      let count = try self.context.count(for: request)
      return count
    } catch {
      return nil
    }
  }
  
  //  // MARK: - Save
  func saveContext () {
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
}
/*
 - context를 이용해서 Managed Object를 생성, 저장, 관리, fetch 할 수 있음
 - 우리가 만든 entity에 데이터를 저장해야 함
 - model을 먼저 만들어서 model의 프로퍼티를 각 entity에 저장하고,
 해당 entity를 사용해서 Object를 생성 및 value를 저장해준다.
 */

