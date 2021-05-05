//
//  TideTimesViewModel.swift
//  TideApp
//
//  Created by Sophie Clark on 04/05/2021.
//

import Foundation
import Combine

final class TideTimesViewModel: ObservableObject {
  
  @Published var locationName: String = ""
  @Published var subTitle: String = ""
  @Published var tideTimes: [TideTimeTempObject] = []
  @Published var tideHeight: String = ""
  
  init() {
    getTideTimes()
  }
  
  private func getTideTimes() {
    // TODO: add call to network layer to get data
    locationName = "Hammersmith Bridge"
    subTitle = "Tide times"
    tideTimes = [TideTimeTempObject(tideTime: "High: 3:28 AM"), TideTimeTempObject(tideTime: "Low: 9:41 AM"), TideTimeTempObject(tideTime: "High: 3:55 PM"), TideTimeTempObject(tideTime: "Low: 9:55 PM")]
    tideHeight = "Current tide height: 0.78m"
  }
}

struct TideTimeTempObject: Identifiable {
  let id = UUID()
  let tideTime: String
}
