//
//  TideTimesInfoView.swift
//  TideApp
//
//  Created by John Sanderson on 19/05/2021.
//

import SwiftUI

struct TideTimesInfoView: View {
  
  let weatherInfo: WeatherInfo
  @State var animate: Bool = false
  
  var body: some View {
    ScrollView(.vertical, showsIndicators: false, content: {
      VStack(alignment: .leading, spacing: nil, content: {
        TitleLabel(text: weatherInfo.locationName)
          .accessibility(label: Text("You are looking at tide times for \(weatherInfo.locationName)"))
          .padding([.bottom, .top], PaddingValues.medium)
        SubtitleLabel(text: weatherInfo.subTitle)
          .padding(.bottom, PaddingValues.tiny)
        if let tideStatus = weatherInfo.tideTimes.current?.tideType.description.full {
          BodyLabel(text: tideStatus)
            .padding(.bottom, PaddingValues.tiny)
        }
        ForEach(weatherInfo.tideTimes) { tideTime in
          BodyLabel(text: "\(tideTime.tideType.rawValue.capitalized): \(tideTime.tideTime)")
        }
        if let waterTemperature = weatherInfo.waterTemperature {
          SubtitleLabel(text: waterTemperature)
            .padding([.bottom, .top], PaddingValues.small)
        }
        SubtitleLabel(text: "Tide heights")
        GeometryReader { reader in
          TideChartView(animate: animate, tideData: weatherInfo.tideTimes, tideHeight: weatherInfo.tideHeight).frame(maxWidth: .infinity, minHeight: 150, alignment: .topLeading)
        }
      })
      .padding([.leading, .trailing], PaddingValues.medium)
    })
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    .onAppear(perform: {
      withAnimation(.easeInOut(duration: 2)) {
        self.animate.toggle()
      }
    })
  }
}

struct TideTimesInfoView_Previews: PreviewProvider {
    static var previews: some View {
      TideTimesInfoView(weatherInfo: .init(locationName: "Brighton", subTitle: "Tide times", tideTimes: [], tideHeight: nil, waterTemperature: nil))
    }
}
