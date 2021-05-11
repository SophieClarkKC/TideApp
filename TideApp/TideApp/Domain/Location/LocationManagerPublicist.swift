//
//  LocationManagerPublicist.swift
//  TideApp
//
//  Created by Dan Smith on 11/05/2021.
//

import Combine
import CoreLocation

protocol LocationManagerPublicistType: CLLocationManagerDelegate {
  func authorisationPublisher() -> AnyPublisher<CLAuthorizationStatus, Never>
  func locationPublisher() -> AnyPublisher<[CLLocation], Never>
  func errorPublisher() -> AnyPublisher<Error, Never>
}

class LocationManagerPublicist: NSObject, LocationManagerPublicistType {

  let authorisationSubject = PassthroughSubject<CLAuthorizationStatus, Never>()
  let locationSubject = PassthroughSubject<[CLLocation], Never>()
  let errorSubject = PassthroughSubject<Error, Never>()

  func authorisationPublisher() -> AnyPublisher<CLAuthorizationStatus, Never> {
    return Just(CLLocationManager.authorizationStatus())
      .merge(with: authorisationSubject.compactMap { $0 })
      .eraseToAnyPublisher()
  }

  func locationPublisher() -> AnyPublisher<[CLLocation], Never> {
    return locationSubject.eraseToAnyPublisher()
  }

  func errorPublisher() -> AnyPublisher<Error, Never> {
    return errorSubject.eraseToAnyPublisher()
  }

  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    authorisationSubject.send(manager.authorizationStatus)
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    locationSubject.send(locations)
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    errorSubject.send(error)
  }
}

extension CLAuthorizationStatus: CustomStringConvertible {
  public var description: String {
    switch self {
    case .authorizedAlways:
      return "Always Authorized"
    case .authorizedWhenInUse:
      return "Authorized When In Use"
    case .denied:
      return "Denied"
    case .notDetermined:
      return "Not Determined"
    case .restricted:
      return "Restricted"
    @unknown default:
      return "Unknown"
    }
  }
}
