//
//  TideTimesView.swift
//  TideApp
//
//  Created by Sophie Clark on 04/05/2021.
//

import SwiftUI
import Combine
import CoreLocation

struct TideTimesView<ViewModel: TideTimesViewModelType>: View {

  @ObservedObject var viewModel: ViewModel

  var body: some View {
    makeView(for: viewModel.state)
      .background(Color.backgroundColor.ignoresSafeArea(.all, edges: [.top, .bottom]))
      .onAppear { viewModel.getTideTimes() }
  }

  private func makeView(for state: TideTimesState) -> AnyView {
    switch viewModel.state {
    case .idle:
      return AnyView(Color.backgroundColor)

    case .loading:
      return AnyView(TitleLabel(text: "Loading..."))

    case .error(let error):
      return AnyView(ErrorView(message: error.localizedDescription, buttonAction: { viewModel.getTideTimes() }))

    case .success(let info):
      return AnyView(TideTimesInfoView(weatherInfo: info))
    }
  }
}

struct TideTimesView_Previews: PreviewProvider {
  static var previews: some View {
    let viewModel = TideTimesLocalViewModel(weatherInfo: .init(locationName: "Brighton", subTitle: "Tide times", tideTimes: [], tideHeight: nil, waterTemperature: nil))
    return TideTimesView(viewModel: viewModel)
  }
}
