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
      List {
        ForEach(viewModel.searchResults, id: \.self) { Text($0) }
      }
      .navigationTitle("Search")
      .overlay(
        ViewControllerResolver { viewController in
          viewController.navigationItem.searchController = searchControllerProvider.searchController
        }
      )
    }
  }
}

struct SearchView_Previews: PreviewProvider {
  static var previews: some View {
    SearchView(viewModel: .init())
  }
}
