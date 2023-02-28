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
    window = UIWindow(windowScene: windowScene)
    
//    let homeVC = HomeViewController()
//    homeVC.view.backgroundColor = UIColor(hex: "FBF8F3")
//    let navigationController = UINavigationController(rootViewController: homeVC)
    
//    window?.rootViewController = navigationController
    window?.rootViewController = MainTabBarController()
    window?.makeKeyAndVisible()
  }
  
  func sceneDidEnterBackground(_ scene: UIScene) {
    
    PersistenceManager.shared.saveContext()
  }
}

