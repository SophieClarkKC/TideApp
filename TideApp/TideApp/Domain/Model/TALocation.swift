//
//  TALocation.swift
//  TideApp
//
//  Created by Marco Guerrieri on 20/05/2021.
//

import Foundation
import CoreLocation

struct TALocation: Codable {
  let name: String
  let latitude: Double
  let longitude: Double

  init(name: String, location: CLLocation) {
    self.name = name
    self.latitude = location.coordinate.latitude
    self.longitude = location.coordinate.longitude
  }
}
