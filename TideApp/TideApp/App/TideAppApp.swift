//
//  TideAppApp.swift
//  TideApp
//
//  Created by Sophie Clark on 29/04/2021.
//

import UIKit
import SwiftUI

@main
struct TideAppApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  
  var body: some Scene {
    WindowGroup {
      TideTimesView(viewModel: TideTimesViewModel(weatherFetcher: WeatherDataFetcher()))
        .environmentObject(LocationObject())
    }
  }
}
