//
//  TideTimesView.swift
//  TideApp
//
//  Created by Sophie Clark on 04/05/2021.
//

import SwiftUI
import Combine
import CoreLocation

struct TideTimesView: View {
  @ObservedObject var viewModel: TideTimesViewModel
  @StateObject var userLocator = UserLocator()

  var body: some View {
    makeView(for: viewModel.state)
      .background(Color.backgroundColor.ignoresSafeArea(.all, edges: [.top, .bottom]))
      .onAppear(perform: {
        userLocator.start()
      })
      .onChange(of: userLocator.location, perform: {
        viewModel.getTideTimes(at: $0)
      })
  }
  
  private func makeView(for state: TideTimesViewModel.State) -> AnyView {
    switch viewModel.state {
    case .idle:
      return AnyView(Color.backgroundColor)
    case .loading:
      return AnyView(TitleLabel(text: "Loading..."))
    case .error(let error):
      return AnyView(ErrorView(error: error, buttonAction: { viewModel.getTideTimes(at: userLocator.location) }))
    case .success(let info):
      return AnyView(TideInfoView(weatherInfo: info))
    }
  }
}

struct TideTimesView_Previews: PreviewProvider {
  static var previews: some View {
    TideTimesView(viewModel: TideTimesViewModel(weatherFetcher: WeatherDataFetcher()))
  }
}
