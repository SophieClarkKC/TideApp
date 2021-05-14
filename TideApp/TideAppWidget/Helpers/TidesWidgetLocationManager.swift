//
//  TidesWidgetLocationManager.swift
//  TideApp
//
//  Created by Marco Guerrieri on 14/05/2021.
//

import Foundation
import CoreLocation

final class TidesWidgetLocationManager: NSObject, CLLocationManagerDelegate {
  private var completion: ((CLLocation?)->())?
  private let locationManager: CLLocationManager

  init(locationManager: CLLocationManager) {
    self.locationManager = locationManager
    super.init()
    self.locationManager.delegate = self
  }

  func isAuthorized() -> Bool {
    return locationManager.isAuthorizedForWidgetUpdates
  }

  func retrieveLocation(completion: ((CLLocation?)->())?) {
    self.completion = completion
    locationManager.startUpdatingLocation()
    locationManager.requestWhenInUseAuthorization()
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.first {
      completion?(location)
    } else {
      completion?(nil)
    }
    cancel()
    completion = nil
  }

  private func cancel() {
    locationManager.stopUpdatingLocation()
  }
}
