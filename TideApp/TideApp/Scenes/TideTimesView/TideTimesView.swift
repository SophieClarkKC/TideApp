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
    switch viewModel.state {
    case .loading:
      TitleLabel(text: "Loading...")
        .onAppear(perform: {
          viewModel.getTideTimes()
        })
    case .error(let error):
      ErrorView(error: error, buttonAction: { viewModel.getTideTimes() })
    case .success(let info):
      TideInfoView(weatherInfo: info)
    }
  }
}

struct TideTimesView_Previews: PreviewProvider {
  static var previews: some View {
    TideTimesView(viewModel: TideTimesViewModel(weatherFetcher: WeatherDataFetcher()))
  }
}
