//
//  TideInfoView.swift
//  TideApp
//
//  Created by Sophie Clark on 12/05/2021.
//

import SwiftUI
import Combine

struct TideInfoView: View {
  @State var weatherInfo: TideTimesViewModel.WeatherInfo
  
  var body: some View {
    ScrollView(.vertical, showsIndicators: false, content: {
      VStack(alignment: .leading, spacing: nil, content: {
        TitleLabel(text: weatherInfo.locationName)
          .accessibility(label: Text("You are looking at tide times for \(weatherInfo.locationName)"))
          .padding([.bottom, .top], PaddingValues.medium)
        SubtitleLabel(text: weatherInfo.subTitle)
          .padding(.bottom, PaddingValues.tiny)
        if let tideStatus = weatherInfo.tideStatus {
          BodyLabel(text: tideStatus)
            .padding(.bottom, PaddingValues.tiny)
        }
        ForEach(weatherInfo.tideTimes) { tideTime in
          BodyLabel(text: "\(tideTime.tideType.rawValue.capitalized): \(tideTime.tideTime)")
        }
        if let tideHeight = weatherInfo.tideHeight {
          SubtitleLabel(text: tideHeight)
            .padding([.bottom, .top], PaddingValues.small)
        }
        if let waterTemperature = weatherInfo.waterTemperature {
          SubtitleLabel(text: waterTemperature)
            .padding([.bottom, .top], PaddingValues.small)
        }
        TideChartView(tideData: weatherInfo.tideTimes)
      })
      .padding([.leading, .trailing], PaddingValues.medium)
    })
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
  }
}

struct TideInfoView_Previews: PreviewProvider {
  static var previews: some View {
    TideInfoView(weatherInfo: TideTimesViewModel.WeatherInfo(locationName: "Brighton", subTitle: "Tide times", tideTimes: [], tideHeight: nil, waterTemperature: nil, tideStatus: nil))
  }
}
