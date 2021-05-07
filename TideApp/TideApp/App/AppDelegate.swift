//
//  AppDelegate.swift
//  TideApp
//
//  Created by Marco Guerrieri on 04/05/2021.
//

import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    print("Application started with\nBase URL: \(AppConfig.baseURL)\nEnvironment: \(AppConfig.isProdEnv ? "Production" : "Mock")")
    return true
  }
}