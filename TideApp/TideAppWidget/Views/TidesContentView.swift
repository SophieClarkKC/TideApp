//
//  TidesContentView.swift
//  TideApp
//
//  Created by Marco Guerrieri on 10/05/2021.
//

import SwiftUI

struct TidesContentView: View {
  @Environment(\.widgetFamily) private var widgetFamily

  var place: String
  var weatherData: WeatherData

  var body: some View {
    ZStack {
      Color.backgroundColor.ignoresSafeArea()
      switch widgetFamily {
      case .systemSmall:
        SmallSizeView(place: place,
                      tideStatus: getTideStatus(),
                      waterTemperature: getWaterTemperature())
      case .systemMedium:
        MediumSizeView(place: place,
                       tideStatus: getTideStatus(),
                       waterTemperature: getWaterTemperature(),
                       tidesTimes: getTideTimes())
      case .systemLarge:
        LargeSizeView(place: place,
                      tideStatus: getTideStatus(),
                      waterTemperature: getWaterTemperature(),
                      tidesTimes: getTideTimes())
      @unknown default:
        fatalError()
      }
    }
  }

  func getWaterTemperature() -> String? {
    guard let currentTemperature = weatherData.currentWaterTemperature(with: Date()) else { return nil }
    return "Water at ~\(String(format: "%.0f", currentTemperature))c"
  }

  func getTideStatus() -> String? {
    return weatherData.tideStatusText(with: Date(), abbreviated: true) ?? nil
  }

  func getTideTimes() -> [WeatherData.Weather.Tide.TideData]? {
    return weatherData.weather.first?.tides.first?.tideData
  }
}

private struct SmallSizeView: View {
  var place: String
  var tideStatus: String?
  var waterTemperature: String?

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      Spacer()
      SubtitleLabel(text: place)
      if let tideStatus = tideStatus {
        Spacer(minLength: 1)
        BodyLabel(text: tideStatus)
      }
      if let waterTemperature = waterTemperature {
        Spacer(minLength: 1)
        BodyLabel(text: waterTemperature)
      }
      Spacer(minLength: 2)
    }
  }
}

private struct MediumSizeView: View {
  var place: String
  var tideStatus: String?
  var waterTemperature: String?
  var tidesTimes: [WeatherData.Weather.Tide.TideData]?

  var body: some View {
    VStack (alignment: .center, spacing: 8) {
      Spacer()
      SubtitleLabel(text: place)
      HStack(alignment: .center, spacing: 8) {
        VStack(alignment: .leading, spacing: 0) {
          if let tideStatus = tideStatus {
            BodyLabel(text: tideStatus)
          }
          if let waterTemperature = waterTemperature {
            BodyLabel(text: waterTemperature)
          }
        }

        Divider()

        VStack(alignment: .leading, spacing: 0) {
          if let tidesTimes = tidesTimes {
            TidesTimesView(tidesTimes: tidesTimes)
          }
        }
      }
      Spacer()
    }
  }
}

private struct LargeSizeView: View {
  var place: String
  var tideStatus: String?
  var waterTemperature: String?
  var tidesTimes: [WeatherData.Weather.Tide.TideData]?

  var body: some View {
    VStack(alignment: .center, spacing: 2) {
      Spacer(minLength: 2)
      SubtitleLabel(text: place)
      if tideStatus != nil || waterTemperature != nil {
        Spacer(minLength: 2)
      }

      if let tideStatus = tideStatus {
        BodyLabel(text: tideStatus)
      }
      if let waterTemperature = waterTemperature {
        BodyLabel(text: waterTemperature)
      }

      if let tidesTimes = tidesTimes {
        Spacer(minLength: 2)
        Divider()
        Spacer(minLength: 2)
        TidesTimesView(tidesTimes: tidesTimes)
        Spacer(minLength: 2)
      }
      Spacer(minLength: 2)
    }
  }
}

private struct TidesTimesView: View {
  var tidesTimes: [WeatherData.Weather.Tide.TideData]
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      ForEach(tidesTimes) { tideTime in
        BodyLabel(text: "\(tideTime.tideType.rawValue.capitalized): \(tideTime.tideTime)")
      }
    }
  }
}
