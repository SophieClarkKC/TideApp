//
//  TidesContentView.swift
//  TideApp
//
//  Created by Marco Guerrieri on 10/05/2021.
//

import SwiftUI

struct TidesContentView: View {
  @Environment(\.widgetFamily) private var widgetFamily

  var viewModel: TidesContentViewModel

  var body: some View {
    ZStack {
      Color.backgroundColor.ignoresSafeArea()
      switch widgetFamily {
      case .systemSmall:
        SmallSizeView(viewModel: viewModel)

      case .systemMedium:
        MediumSizeView(viewModel: viewModel)

      case .systemLarge:
        LargeSizeView(viewModel: viewModel)

      @unknown default:
        fatalError()
      }
    }
  }
}

private struct SmallSizeView: View {
  var viewModel: TidesContentViewModel

  var body: some View {
    HStack {
      Spacer(minLength: 4)
      VStack(alignment: .leading, spacing: 0) {
        Spacer()
        SubtitleLabel(text: viewModel.place)
        if let tideStatus = viewModel.tideStatus {
          Spacer(minLength: 1)
          BodyLabel(text: tideStatus)
        }
        if let waterTemperature = viewModel.waterTemperature {
          Spacer(minLength: 1)
          BodyLabel(text: waterTemperature)
        }
        Spacer(minLength: 2)
      }
      Spacer(minLength: 4)
    }
  }
}

private struct MediumSizeView: View {
  var viewModel: TidesContentViewModel

  var body: some View {
    VStack (alignment: .center, spacing: 8) {
      Spacer()
      SubtitleLabel(text: viewModel.place)
      HStack(alignment: .center, spacing: 8) {
        VStack(alignment: .leading, spacing: 0) {
          if let tideStatus = viewModel.tideStatus {
            BodyLabel(text: tideStatus)
          }
          if let waterTemperature = viewModel.waterTemperature {
            BodyLabel(text: waterTemperature)
          }
        }

        Divider()

        VStack(alignment: .leading, spacing: 0) {
          if let tidesTimes = viewModel.tidesTimes {
            TidesTimesView(tidesTimes: tidesTimes)
          }
        }
      }
      Spacer()
    }
  }
}

private struct LargeSizeView: View {
  var viewModel: TidesContentViewModel

  var body: some View {
    VStack(alignment: .center, spacing: 2) {
      MediumSizeView(viewModel: viewModel)
      Divider()
      HStack {
        Spacer(minLength: 12)
        TideChartView(animate: true,
                      tideData: viewModel.tidesTimes ?? [],
                      tideHeight: viewModel.tideHeight)
          .frame(maxWidth: .infinity,
                 minHeight: 140,
                 alignment: .center)
        Spacer(minLength: 12)
      }
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
