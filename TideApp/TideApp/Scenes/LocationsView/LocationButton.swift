//
//  LocationButton.swift
//  TideApp
//
//  Created by John Sanderson on 14/05/2021.
//

import SwiftUI

struct LocationButton: View {

  enum `Type` {
    case current
    case favourite
  }

  @State private var showSheet = false
  private let weatherInfo: WeatherInfo
  private let type: Type

  init(weatherInfo: WeatherInfo, type: Type) {
    self.weatherInfo = weatherInfo
    self.type = type
  }

  var body: some View {
    Button(action: {
      showSheet.toggle()
    }, label: {
      HStack(spacing: PaddingValues.small) {
        Image(type.systemAsset)
        SubtitleLabel(text: weatherInfo.locationName)
        Spacer()
        VStack(alignment: .leading, spacing: PaddingValues.tiny) {
          BodyLabel(text: weatherInfo.tideTimes.current?.tideType.description.abbreviated ?? "")
          BodyLabel(text: weatherInfo.tideTimes.next?.description ?? "")
        }
      }
      .padding(PaddingValues.large)
      .background(Color.backgroundColor)
    })
    .accentColor(.primaryActionColor)
    .background(Rectangle().shadow(radius: 4))
    .sheet(isPresented: $showSheet, content: {
      TideTimesView(viewModel: TideTimesLocalViewModel(weatherInfo: weatherInfo))
    })
  }
}

private extension LocationButton.`Type` {

  var systemAsset: SystemAsset {
    switch self {
    case .current: return .location
    case .favourite: return .favouriteFilled
    }
  }
}
