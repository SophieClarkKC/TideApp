//
//  LocationsView.swift
//  TideApp
//
//  Created by John Sanderson on 13/05/2021.
//

import SwiftUI

struct LocationsView: View {

  @ObservedObject var viewModel: LocationsViewModel

  var body: some View {
    ZStack {
      Color.backgroundColor
        .ignoresSafeArea()

      makeView(for: viewModel.state)
    }
    .onAppear { viewModel.start() }
  }

  private func makeView(for state: LocationsViewModel.State) -> AnyView {
    switch viewModel.state {

    case .idle:
      return AnyView(Color.backgroundColor)

    case .loading:
      return AnyView(TitleLabel(text: "Loading..."))

    case .error(let error):
      return AnyView(ErrorView(message: error, buttonAction: { viewModel.refresh() }))

    case .success(let info):
      return AnyView(LocationInfoView(weatherInfo: info))
    }
  }
}

struct LocationsView_Previews: PreviewProvider {
  static var previews: some View {
    LocationsView(viewModel: .init())
  }
}
