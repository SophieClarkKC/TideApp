//
//  LocationObject.swift
//  TideApp
//
//  Created by Dan Smith on 11/05/2021.
//

import Combine
import CoreLocation

class LocationObject: ObservableObject {
  @Published var authorisationStatus = CLAuthorizationStatus.notDetermined
  @Published var location: CLLocation?
  @Published var latitude: Double?
  @Published var error: Error?

  let manager: CLLocationManager
  let publicist: LocationManagerPublicistType

  var cancellables = [AnyCancellable]()

  init (publicist: LocationManagerPublicistType = LocationManagerPublicist()) {
    let manager = CLLocationManager()
    manager.delegate = publicist
    manager.desiredAccuracy = kCLLocationAccuracyBest

    self.manager = manager
    self.publicist = publicist

    setupSubscriptions()
  }

  private func setupSubscriptions() {
    setupAuthorisationPublisher()
    setupLocationPublisher()
    setupErrorPublisher()
  }

  private func setupAuthorisationPublisher() {
    let authorisationPublisher = publicist.authorisationPublisher()

    authorisationPublisher
      .sink(receiveValue: beginUpdates)
      .store(in: &cancellables)

    authorisationPublisher
      .receive(on: DispatchQueue.main)
      .assign(to: &$authorisationStatus)
  }

  private func setupLocationPublisher() {
    let locationPublisher = publicist.locationPublisher()

    locationPublisher
      .flatMap(Publishers.Sequence.init(sequence:))
      .map { $0 as CLLocation? }
      .receive(on: DispatchQueue.main)
      .assign(to: &$location)
  }

  private func setupErrorPublisher() {
    let errorPublisher = publicist.errorPublisher()
  }

  private func beginUpdates(_ authorizationStatus: CLAuthorizationStatus) {
    if authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse {
      manager.startUpdatingLocation()
    }
  }

  func authorise() {
    manager.requestWhenInUseAuthorization()
  }
}
