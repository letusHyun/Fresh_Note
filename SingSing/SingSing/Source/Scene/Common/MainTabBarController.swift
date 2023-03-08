//
//  MainTabBarController.swift
//  SingSing
//
//  Created by SeokHyun on 2023/02/14.
//

import UIKit

import SnapKit

final class MainTabBarController: UITabBarController {
  
  // MARK: - LifeCycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureTabBar()
  }
  
  // MARK: - Configures
  
  private func configureTabBar() {
    configureItems()
    
    //UITabBarAppearance
    let appearance = UITabBarAppearance()
    appearance.backgroundColor = SSType.background.color
    appearance.shadowColor = .clear
    appearance
      .stackedLayoutAppearance
      .selected
      .titleTextAttributes = [
        .foregroundColor : SSType.lv3.color,
      ]
    
    tabBar.standardAppearance = appearance
  }
  
  private func configureItems() {
    //홈
    let homeVC = HomeViewController()
    let homeNavi = UINavigationController(rootViewController: homeVC)
    let homeItem = UITabBarItem(
      title: "홈",
      image: UIImage(systemName: "house"),
      selectedImage: UIImage(systemName: "house.fill")?
        .withTintColor(SSType.lv3.color, renderingMode: .alwaysOriginal)
    )
    homeVC.tabBarItem = homeItem

    //캘린더
    let calendarVC = CalendarViewController()
    let calendarItem = UITabBarItem(
      title: "캘린더",
      image: UIImage(systemName: "calendar"),
      selectedImage: UIImage(systemName: "calendar")?
        .withTintColor(SSType.lv3.color, renderingMode: .alwaysOriginal)
    )
    calendarVC.tabBarItem = calendarItem
    
    //핀
    let PinVC = PinViewController()
    let PinItem = UITabBarItem(
      title: "핀",
      image: UIImage(systemName: "pin"),
      selectedImage: UIImage(systemName: "pin.fill")?
        .withTintColor(SSType.lv3.color, renderingMode: .alwaysOriginal)
    )
    PinVC.tabBarItem = PinItem
    
    //마이
    let myVC = MyViewController()
    let myItem = UITabBarItem(
      title: "마이",
      image: UIImage(systemName: "person"),
      selectedImage: UIImage(systemName: "person.fill")?
        .withTintColor(SSType.lv3.color, renderingMode: .alwaysOriginal)
    )
    myVC.tabBarItem = myItem
    
    self.viewControllers = [homeNavi, calendarVC, PinVC, myVC]
  }
}
