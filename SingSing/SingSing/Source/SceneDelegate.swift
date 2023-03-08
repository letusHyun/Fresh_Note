//
//  SceneDelegate.swift
//  SingSing
//
//  Created by SeokHyun on 2023/02/13.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?
  
  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    self.window = UIWindow(windowScene: windowScene)
    
    if Storage.isFirstTime() {
      self.window?.rootViewController = OnboardingViewController()
    } else {
      self.window?.rootViewController = MainTabBarController()
    }
    
    self.window?.makeKeyAndVisible()
  }
  
  func sceneDidEnterBackground(_ scene: UIScene) {
    PersistenceManager.shared.saveContext()
  }
}
