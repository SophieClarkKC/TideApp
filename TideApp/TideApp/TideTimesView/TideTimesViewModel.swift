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
  typealias Hourly = WeatherData.Weather.Hourly
  
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
        self.tideHeight = "Current tide height: ~\(String(format: "%.2f", currentTideHeight))m"
        if let hourly = weatherData.weather.first?.hourly {
          let currentTemperature = self.currentWaterTemperature(from: hourly)
          self.waterTemperature = "Current water temperature: ~\(String(format: "%.0f", currentTemperature))c"
        }
      }
      .store(in: &cancellables)
  }
  
  private func calculateCurrentTideHeight(from tideData: [TideData]) -> Double {
    let now = Date()
    let tideDates = tideData.compactMap { data in
      data.tideDateTime.date(with: .dateTime)
    }
    let closestDates = now.closestDates(in: tideDates)
    
    let lastTideData = tideData.first(where: { data in
      data.tideDateTime.date(with: .dateTime) == closestDates.first
    })
    let nextTideData = tideData.first(where: { data in
      data.tideDateTime.date(with: .dateTime) == closestDates.last
    })
    
    guard let lastTideData = lastTideData,
          let nextTideData = nextTideData,
          let lastTideTime = closestDates.first,
          let nextTideTime = closestDates.last,
          let lastTideHeight = Double(lastTideData.tideHeightM),
          let nextTideHeight = Double(nextTideData.tideHeightM) else {
      return 0
    }
    
    return getWeightedValue(from: lastTideTime, middleDate: now, endDate: nextTideTime, startValue: lastTideHeight, endValue: nextTideHeight)
  }
  
  private func currentWaterTemperature(from hourlyData: [Hourly]) -> Double {
    let timeNowDate = Date().string(with: .timeNoColon).date(with: .timeNoColon)
    let closestTwoDates = timeNowDate?.closestDates(in: hourlyData.compactMap { $0.time.date(with: .timeNoColon) })
    guard let closestDates = closestTwoDates else {
      return 0
    }
    
    guard let lastTempData = hourlyData.first(where: { data in data.time.date(with: .timeNoColon) == closestDates.first }) else {
      return 0
    }
    guard let nextTempData = hourlyData.first(where: { data in data.time.date(with: .timeNoColon) == closestDates.first }) else {
      return Double(lastTempData.waterTempC) ?? 0
    }
    
    guard let timeNow = timeNowDate,
          let lastTempTime = closestDates.first,
          let nextTempTime = closestDates.last,
          let lastTemp = Double(lastTempData.waterTempC),
          let nextTemp = Double(nextTempData.waterTempC) else {
      return 0
    }
    
    return getWeightedValue(from: lastTempTime, middleDate: timeNow, endDate: nextTempTime, startValue: lastTemp, endValue: nextTemp)
  }
  
  private func getWeightedValue(from beginDate: Date, middleDate: Date, endDate: Date, startValue: Double, endValue: Double) -> Double {
    let beginningAndEndDifference = endDate.difference(from: beginDate)
    let middleAndBeginningDifference = middleDate.difference(from: beginDate)
    
    let safeMiddleAndBeginningDifference = middleAndBeginningDifference == 0 ? 1 : middleAndBeginningDifference
    let safeTimeDifferenceBetweenTides = beginningAndEndDifference == 0 ? 1 : beginningAndEndDifference
    
    let timeFraction = safeMiddleAndBeginningDifference / safeTimeDifferenceBetweenTides
    let deltaLowHigh = startValue - endValue
    let heightFraction = timeFraction * deltaLowHigh
    let currentHeight = heightFraction + endValue
    
    return currentHeight
  }
}
