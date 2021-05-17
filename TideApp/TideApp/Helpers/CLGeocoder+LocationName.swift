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
          if let locationName = placemarks?.compactMap({ $0.getLocationNameIfPresent }).first {
            promise(.success((locationName, weatherData)))
          } else {
            promise(.success(("Lat: \(latitude), Lon: \(longitude)", weatherData)))
          }
        }
      }
    }.eraseToAnyPublisher()
  }
}

fileprivate extension CLPlacemark {
  var getLocationNameIfPresent: String? {
    return subLocality ?? subAdministrativeArea ?? locality ?? name ?? inlandWater ?? ocean
  }
}
