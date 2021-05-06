//
//  CLGeocoder + LocationName.swift
//  TideApp
//
//  Created by Sophie Clark on 06/05/2021.
//

import Foundation
import CoreLocation
import Combine

extension CLGeocoder {
  func getLocationName(for weatherData: WeatherData) -> AnyPublisher<(String, WeatherData), WeatherError> {
    return Future<(String, WeatherData), WeatherError> { [weak self] promise in
      guard let strongSelf = self else {
        return
      }
      guard let nearestArea = weatherData.nearestArea.first, let latitude = CLLocationDegrees(nearestArea.latitude), let longitude = CLLocationDegrees(nearestArea.longitude) else {
        promise(.failure(WeatherError.parsing(description: "Couldn't find location")))
        return
      }
      strongSelf.reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { placemarks, error in
        if let error = error {
          promise(.failure(WeatherError.parsing(description: error.localizedDescription)))
        } else {
          if let placemark = placemarks?.first(where: { $0.subLocality != nil }), let locationName = placemark.subLocality {
            promise(.success((locationName, weatherData)))
          } else if let placemark = placemarks?.first(where: { $0.subAdministrativeArea != nil }), let locationName = placemark.subAdministrativeArea {
            promise(.success((locationName, weatherData)))
          } else {
            promise(.success(("Dunno", weatherData)))
          }
        }
      }
    }.eraseToAnyPublisher()
  }
}
