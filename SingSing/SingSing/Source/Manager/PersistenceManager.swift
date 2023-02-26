//
//  PersistenceManager.swift
//  SingSing
//
//  Created by SeokHyun on 2023/02/13.
//

import CoreData
import Foundation

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
  
  var entity: NSEntityDescription? {
    return NSEntityDescription.entity(forEntityName: "Food", in: self.context)
  }
  
  var fetchRequest: NSFetchRequest<Food> {
    return Food.fetchRequest()
  }
  
  // MARK: - LifeCycle
  
  private init() { }
  
  // MARK: - Fetch
  
  func fetchFoods() -> [Food] {
    do {
      let results = try context.fetch(fetchRequest)
      
      return results
    } catch {
      print("DEBUG: \(error.localizedDescription)")
    }
    return []
  }
  
  func fetchFoodModels() -> [FoodModel] {
    let foods = fetchFoods()
    var foodModels = [FoodModel]()
    
    for food in foods {
      foodModels.append(FoodModel(
        uuid: food.uuid,
        name: food.name,
        expirationDate: food.expirationDate,
        consumptionDate: food.consumptionDate,
        extraDescription: food.extraDescription,
        category: food.category,
        thumbnail: food.thumbnail
      ))
    }
    return foodModels
  }
  
  // MARK: - Insert
  
  @discardableResult
  func insertFood(foodModel: FoodModel) -> Bool {
    // 2. Entity를 가져온다
    if let entity = self.entity {
      // 3. NSManagedObject를 만든다. (Entity로 형변환)
      let object = NSManagedObject(entity: entity, insertInto: self.context)
      
      // 4. NSManagedObject에 값을 세팅한다.
      object.setValue(foodModel.name, forKey: "name")
      object.setValue(foodModel.uuid, forKey: "uuid")
      object.setValue(foodModel.expirationDate, forKey: "expirationDate")
      object.setValue(foodModel.consumptionDate, forKey: "consumptionDate")
      object.setValue(foodModel.extraDescription, forKey: "extraDescription")
      object.setValue(foodModel.category, forKey: "category")
      object.setValue(foodModel.thumbnail, forKey: "thumbnail")
      
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
  
  @discardableResult
  func editFood(foodModel: FoodModel) -> Bool {
    
    let foods = PersistenceManager.shared.fetchFoods()
    
    for selectedFood in foods {
      if selectedFood.uuid == foodModel.uuid {
        selectedFood.name = foodModel.name
        selectedFood.expirationDate = foodModel.expirationDate
        selectedFood.consumptionDate = foodModel.consumptionDate
        selectedFood.category = foodModel.category
        selectedFood.extraDescription = foodModel.extraDescription
        selectedFood.thumbnail = foodModel.thumbnail
      }
    }
    
    //[최종] NSManagedObjectContext에 저장한다.
    do {
      try self.context.save()
      return true
    } catch {
      print("DEBUG: \(error.localizedDescription)")
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
  
  // TODO: - 제네릭 수정
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

