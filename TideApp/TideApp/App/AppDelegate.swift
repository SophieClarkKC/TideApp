//
//  AppDelegate.swift
//  TideApp
//
//  Created by Marco Guerrieri on 04/05/2021.
//

import UIKit
import WidgetKit
#if DEBUG
import MockServer
#endif

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    print("Application started with\nBase URL: \(AppConfig.baseURL)\nEnvironment: \(AppConfig.isProdEnv ? "Production" : "Mock")")

    #if DEBUG
    startMockServerIfNeeded()
    #endif

    WidgetCenter.shared.reloadAllTimelines()

    return true
  }
}

#if DEBUG
extension AppDelegate {
  private func startMockServerIfNeeded() {
    if AppConfig.isTestEnv {
      MockServer().start()
    }
  }
}

extension UIWindow {
  open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
    if motion == .motionShake {
      NotificationCenter.default.post(name: UIDevice.deviceDidShakeNotification, object: nil)
    }
  }
}
#endif

extension UIDevice {
  static let deviceDidShakeNotification = Notification.Name(rawValue: "deviceDidShakeNotification")
}
