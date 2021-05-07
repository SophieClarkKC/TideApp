//
//  TideTimesView.swift
//  TideApp
//
//  Created by Sophie Clark on 04/05/2021.
//

import SwiftUI
import Combine

struct TideTimesView: View {
  @ObservedObject var viewModel: TideTimesViewModel
  
  var body: some View {
    ScrollView(.vertical, showsIndicators: false, content: {
      VStack(alignment: .leading, spacing: nil, content: {
        TitleLabel(text: viewModel.locationName)
          .accessibility(label: Text("You are looking at tide times for \(viewModel.locationName)"))
          .padding([.bottom, .top], PaddingValues.medium)
        SubtitleLabel(text: viewModel.subTitle)
          .padding(.bottom, PaddingValues.tiny)
        ForEach(viewModel.tideTimes) { tideTime in
          BodyLabel(text: "\(tideTime.tideType): \(tideTime.tideTime)")
        }
        SubtitleLabel(text: viewModel.tideHeight)
          .padding([.bottom, .top], PaddingValues.small)
        SubtitleLabel(text: viewModel.waterTemperature)
          .padding([.bottom, .top], PaddingValues.small)
      })
      .padding([.leading, .trailing], PaddingValues.medium)
    })
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    .background(Color.backgroundColor.ignoresSafeArea(.all, edges: .top))
    .onAppear(perform: {
      viewModel.getTideTimes()
    })
  }
}

struct TideTimesView_Previews: PreviewProvider {
  static var previews: some View {
    TideTimesView(viewModel: TideTimesViewModel(weatherFetcher: WeatherDataFetcher()))
  }
}
