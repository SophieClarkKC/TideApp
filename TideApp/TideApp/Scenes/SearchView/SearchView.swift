//
//  SearchView.swift
//  TideApp
//
//  Created by John Sanderson on 17/05/2021.
//

import SwiftUI

struct SearchView: View {

  @ObservedObject private var viewModel: SearchViewModel
  private let searchControllerProvider: SearchControllerProvider

  init(viewModel: SearchViewModel) {
    self.viewModel = viewModel
    searchControllerProvider = SearchControllerProvider(resultsUpdater: viewModel)
  }

  var body: some View {
    NavigationView {
      makeView(for: viewModel.state)
        .navigationTitle("Search")
        .overlay(
          ViewControllerResolver { viewController in
            viewController.navigationItem.searchController = searchControllerProvider.searchController
          }.frame(width: 0, height: 0)
        )
        .onAppear {
          viewModel.start()
        }
    }
  }

  private func makeView(for state: SearchViewModel.State) -> AnyView {
    switch viewModel.state {
    case .idle:
      return AnyView(IdleView())
    case .error, .noResults:
      return AnyView(NoResultsView())
    case .success(let results):
      return AnyView(ResultsView(results: results))
    }
  }
}

// MARK: - View States -

private struct IdleView: View {

  var body: some View {
    VStack(alignment: .center, spacing: PaddingValues.medium) {
      SubtitleLabel(text: "Search for a location", alignment: .center)
        .multilineTextAlignment(.center)
      BodyLabel(text: "Tide information will be shown for the nearest marine weather station to your chosen location.", alignment: .center)
      Spacer()
    }
    .padding()
  }
}

private struct NoResultsView: View {

  var body: some View {
    SubtitleLabel(text: "Sorry, no results match this search!", alignment: .center)
      .multilineTextAlignment(.center)
      .padding()
  }
}

private struct ResultsView: View {

  let results: [String]

  var body: some View {
    List {
      ForEach(results, id: \.self) { result in
        Button(action: {}) {
          Text(result)
        }
      }
    }
  }
}

struct SearchView_Previews: PreviewProvider {
  static var previews: some View {
    SearchView(viewModel: .init())
  }
}
