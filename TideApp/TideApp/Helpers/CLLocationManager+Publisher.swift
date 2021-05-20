//
//  CLLocationManager+Publisher.swift
//  TideApp
//
//  Created by Dan Smith on 12/05/2021.
//

import Combine
import CoreLocation

public enum LocationManagerResult {
  case awaiting
  case unauthorized
  case success(CLLocation)
}

extension CLLocationManager {

  public static func publishLocation(requestedByWidget: Bool) -> LocationPublisher {
    return .init(requestedByWidget: requestedByWidget)
  }

  public struct LocationPublisher: Publisher {
    public typealias Output = LocationManagerResult
    public typealias Failure = Never
    private let requestedByWidget: Bool

    init(requestedByWidget: Bool) {
      self.requestedByWidget = requestedByWidget
    }

    public func receive<S>(subscriber: S) where S: Subscriber, Failure == S.Failure, Output == S.Input {
      let subscription = LocationSubscription(subscriber: subscriber, requestedByWidget: requestedByWidget)
      subscriber.receive(subscription: subscription)
    }

    final class LocationSubscription<S: Subscriber> : NSObject, CLLocationManagerDelegate, Subscription where S.Input == Output, S.Failure == Failure {
      private let locationManager = CLLocationManager()
      private let requestedByWidget: Bool

      let subscriber: S

      init(subscriber: S, requestedByWidget: Bool) {
        self.subscriber = subscriber
        self.requestedByWidget = requestedByWidget
        super.init()
        locationManager.delegate = self
        locationManager.distanceFilter = .init(500)
      }

      func request(_ demand: Subscribers.Demand) {
        checkAuthorizationStatusAndStartIfPossible()
      }

      func cancel() {
        locationManager.stopUpdatingLocation()
      }

      func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let mostAccurateLocation = locations.last {
          _ = subscriber.receive(.success(mostAccurateLocation))
        }
      }

      func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAuthorizationStatusAndStartIfPossible()
      }

      private func checkAuthorizationStatusAndStartIfPossible() {
        guard !requestedByWidget else {
          switch locationManager.isAuthorizedForWidgetUpdates {
          case true:
            locationManager.startUpdatingLocation()

          case false:
            _ = subscriber.receive(.unauthorized)
          }
          return
        }

        switch locationManager.authorizationStatus {
        case .denied, .restricted:
          _ = subscriber.receive(.unauthorized)

        case .notDetermined:
          locationManager.requestWhenInUseAuthorization()

        default:
          locationManager.startUpdatingLocation()
        }
      }

    }
  }
}
