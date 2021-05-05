//
//  TideAppApp.swift
//  TideApp
//
//  Created by Sophie Clark on 29/04/2021.
//

import SwiftUI

@main
struct TideAppApp: App {
  var body: some Scene {
    WindowGroup {
      TideTimesView(viewModel: TideTimesViewModel())
    }
  }
}
