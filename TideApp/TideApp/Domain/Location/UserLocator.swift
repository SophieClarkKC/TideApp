//
//  UserLocator.swift
//  LocationExperiment
//
//  Created by Dan Smith on 12/05/2021.
//

import Combine
import CoreLocation

final class UserLocator : ObservableObject {
  @Published var locationResult: LocationManagerResult = .awaiting
  var cancellable: AnyCancellable?

  init(forWidget: Bool) {
    cancellable = CLLocationManager.publishLocation(forWidget: forWidget)
      .eraseToAnyPublisher()
      .assign(to: \.locationResult, on: self)
  }
}
