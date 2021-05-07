//
//  TideTimesViewModel.swift
//  TideApp
//
//  Created by Sophie Clark on 04/05/2021.
//

import Foundation
import Combine
import CoreLocation

final class TideTimesViewModel: ObservableObject {
  typealias TideData = WeatherData.Weather.Tide.TideData
  
  @Published var locationName: String = ""
  @Published var subTitle: String = ""
  @Published var tideTimes: [TideData] = []
  @Published var tideHeight: String = ""
  @Published var waterTemperature: String = ""
  @Published var error: WeatherError?
  
  private var weatherFetcher: WeatherDataFetchable
  private var cancellables = [AnyCancellable]()

  init(weatherFetcher: WeatherDataFetchable) {
    self.weatherFetcher = weatherFetcher
  }
  
  func getTideTimes() {
    weatherFetcher.getStandardWeatherData(lat: 51.489134, lon: -0.229391)
      .receive(on: DispatchQueue.main)
      .flatMap { CLGeocoder().getLocationName(for: $0) }
      .sink { completion in
        switch completion {
        case .failure(let error):
          self.error = error
        case .finished:
          break
        }
      } receiveValue: { (placeName, weatherData) in
        let tideData = weatherData.weather.first?.tides.first?.tideData ?? []
        self.subTitle = "Tide times"
        self.tideTimes = tideData
        self.locationName = placeName
        let currentTideHeight = self.calculateCurrentTideHeight(from: tideData)
        self.tideHeight = "Current tide height: \(String(format: "%.2f", currentTideHeight))m"
      }
      .store(in: &cancellables)
  }
  
  private func calculateCurrentTideHeight(from tideData: [TideData]) -> Double {
    let now = Date()
    let tideDates = tideData.compactMap { data in
      data.tideDateTime.date(with: .dateTime)
    }
    let closestDates = now.closestDates(in: tideDates)
    
    let lastTideTime = tideData.filter { data in
      data.tideDateTime.date(with: .dateTime) == closestDates.first
    }.first
    let nextTideTime = tideData.filter { data in
      data.tideDateTime.date(with: .dateTime) == closestDates.last
    }.first
    
    guard let lastTideTime = lastTideTime, let nextTideTime = nextTideTime else {
      return 0
    }
    
    let timeDifferenceBetweenTides = nextTideTime.tideDateTime.date(with: .dateTime)?.difference(from: lastTideTime.tideDateTime.date(with: .dateTime))
    let lastTimeDifference = now.difference(from: lastTideTime.tideDateTime.date(with: .dateTime))
    
    guard let timeDifferenceBetweenTides = timeDifferenceBetweenTides else {
      return 0
    }
    
    let safeLastTimeDifference = lastTimeDifference == 0 ? 1 : lastTimeDifference
    let safeTimeDifferenceBetweenTides = timeDifferenceBetweenTides == 0 ? 1 : timeDifferenceBetweenTides
    
    let timeFraction = safeLastTimeDifference / safeTimeDifferenceBetweenTides
    let deltaLowHigh = (Double(lastTideTime.tideHeightM) ?? 0) - (Double(nextTideTime.tideHeightM) ?? 0)
    let heightFraction = timeFraction * deltaLowHigh
    let currentHeight = heightFraction + (Double(nextTideTime.tideHeightM) ?? 0)
    
    return currentHeight
  }
}
