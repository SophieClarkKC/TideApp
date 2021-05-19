//
//  UserLocator.swift
//  LocationExperiment
//
//  Created by Dan Smith on 12/05/2021.
//

import Combine
import CoreLocation

final class UserLocator : ObservableObject {
  @Published var location = CLLocation()
  var cancellable: AnyCancellable?

  init() {}

  func start() {
    cancellable = CLLocationManager.publishLocation()
      .assign(to: \.location, on: self)
  }

  func isAuthorizedForWidgetUpdates() -> Bool {
    return CLLocationManager().isAuthorizedForWidgetUpdates
  }
}
