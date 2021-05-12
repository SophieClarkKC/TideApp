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
      struct TideData: Identifiable, Decodable {
        let id = UUID()
        let tideTime, tideHeightM, tideDateTime, tideType: String

        enum CodingKeys: String, CodingKey {
          case tideTime
          case tideHeightM = "tideHeight_mt"
          case tideDateTime
          case tideType = "tide_type"
        }
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
