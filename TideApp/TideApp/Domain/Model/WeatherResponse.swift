//
//  WeatherResponse.swift
//  TideApp
//
//  Created by Dan Smith on 04/05/2021.
//
import Foundation

// MARK: - WeatherResponse
struct WeatherResponse: Decodable {
  let data: WeatherData
}

struct WeatherData: Decodable {
  let request: [LocationRequest]
  let nearestArea: [NearestArea]
  let weather: [Weather]

  enum CodingKeys: String, CodingKey {
    case request
    case nearestArea = "nearest_area"
    case weather
  }

  // MARK: - LocationRequest
  struct LocationRequest: Decodable {
    let query: String
  }

  // MARK: - NearestArea
  struct NearestArea: Decodable {
    let latitude, longitude: String
  }

  // MARK: - Weather
  struct Weather: Decodable {
    let date: String
    let tides: [Tide]
    let hourly: [Hourly]

    // MARK: - Tide
    struct Tide: Decodable {
      let tideData: [TideData]

      enum CodingKeys: String, CodingKey {
        case tideData = "tide_data"
      }

      // MARK: - TideData
      struct TideData: Identifiable {

        enum TideType: String, Codable {
          case high = "HIGH"
          case low = "LOW"
        }

        let id = UUID()
        let tideTime: String
        let tideHeightM: Double
        let tideDateTime: Date
        let tideType: TideType
      }
    }

    // MARK: - Hourly
    struct Hourly: Decodable {
      let time, waterTempC, waterTempF: String

      enum CodingKeys: String, CodingKey {
        case time
        case waterTempC = "waterTemp_C"
        case waterTempF = "waterTemp_F"
      }
    }
  }
}

extension WeatherData {
  func calculateCurrentTideHeight(with date: Date) -> Double? {
    guard let tideData = weather.first?.tides.first?.tideData else {
      return nil
    }
    let tideDates = tideData.compactMap { $0.tideDateTime }
    let closestDates = date.closestDates(in: tideDates)
    
    let lastTideData = tideData.first(where: { data in
      data.tideDateTime == closestDates.first
    })
    let nextTideData = tideData.first(where: { data in
      data.tideDateTime == closestDates.last
    })
    
    guard let lastTideHeight = lastTideData?.tideHeightM,
          let nextTideHeight = nextTideData?.tideHeightM,
          let lastTideTime = closestDates.first,
          let nextTideTime = closestDates.last else {
      return 0
    }
    
    return GeneralHelpers.getWeightedValue(from: lastTideTime, middleDate: date, endDate: nextTideTime, startValue: lastTideHeight, endValue: nextTideHeight)
  }
  
  func currentWaterTemperature(with date: Date) -> Double? {
    guard let hourlyData = weather.first?.hourly else {
      return nil
    }
    let timeNowDate = date.string(with: .timeNoColon).date(with: .timeNoColon)
    let closestTwoDates = timeNowDate?.closestDates(in: hourlyData.compactMap { $0.time.date(with: .timeNoColon) })
    guard let closestDates = closestTwoDates else {
      return nil
    }
    
    guard let lastTempData = hourlyData.first(where: { data in data.time.date(with: .timeNoColon) == closestDates.first }) else {
      return nil
    }
    guard let nextTempData = hourlyData.first(where: { data in data.time.date(with: .timeNoColon) == closestDates.first }) else {
      return Double(lastTempData.waterTempC)
    }
    
    guard let timeNow = timeNowDate,
          let lastTempTime = closestDates.first,
          let nextTempTime = closestDates.last,
          let lastTemp = Double(lastTempData.waterTempC),
          let nextTemp = Double(nextTempData.waterTempC) else {
      return nil
    }
    
    return GeneralHelpers.getWeightedValue(from: lastTempTime, middleDate: timeNow, endDate: nextTempTime, startValue: lastTemp, endValue: nextTemp)
  }

  func tideStatusText(with date: Date, abbreviated: Bool) -> String? {
    guard let status = calculateTideStatus(with: date) else { return nil }
    switch status {
    case .high:
      return abbreviated ? "High Tide": "Currently, the tide is going out"
    case .low:
      return abbreviated ? "Low Tide": "Currently, the tide is coming in"
    }
  }

  private func calculateTideStatus(with date: Date) -> Weather.Tide.TideData.TideType? {
    guard
      let tideData = weather.first?.tides.first?.tideData,
      let dateOfTheClosestTide = date.closestDates(in: tideData.compactMap({ $0.tideDateTime })).first,
      let lastTideData = tideData.first(where: { $0.tideDateTime == dateOfTheClosestTide })
    else {
      return nil
    }
    return lastTideData.tideType
  }
}

extension WeatherData.Weather.Tide.TideData: Decodable {
  enum CodingKeys: String, CodingKey {
    case tideTime
    case tideHeightM = "tideHeight_mt"
    case tideDateTime
    case tideType = "tide_type"
  }
  
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    tideTime = try values.decode(String.self, forKey: .tideTime)
    let tideHeightString = try values.decode(String.self, forKey: .tideHeightM)
    tideHeightM = Double(truncating: NumberFormatter().number(from: tideHeightString) ?? 0)
    tideDateTime = try values.decode(String.self, forKey: .tideDateTime).date(with: .dateTime) ?? Date()
    tideType = try values.decode(TideType.self, forKey: .tideType)
  }
}
