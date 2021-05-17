//
//  TideAppApp.swift
//  TideApp
//
//  Created by Sophie Clark on 29/04/2021.
//

import MockServer
import SwiftUI


@main
struct TideAppApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  @State private var showingMockConfig = false
  
  var body: some Scene {
    WindowGroup {
      TideTimesView(viewModel: TideTimesViewModel(weatherFetcher: WeatherDataFetcher()))
        .popover(isPresented: $showingMockConfig, content: {
          #if DEBUG
          if AppConfig.isTestEnv { MockServer.getMockConfigurationView() }
          #endif
        })
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.deviceDidShakeNotification)) { _ in
          #if DEBUG
          if AppConfig.isTestEnv { showingMockConfig.toggle() }
          #endif
        }
    }
  }
}
