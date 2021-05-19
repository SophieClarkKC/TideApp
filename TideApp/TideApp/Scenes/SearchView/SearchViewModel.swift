//
//  SearchViewModel.swift
//  TideApp
//
//  Created by John Sanderson on 17/05/2021.
//

import UIKit
import Combine
import MapKit

final class SearchViewModel: NSObject, ObservableObject {

  enum State {
    case idle
    case error
    case noResults
    case success([MKPlacemark])
  }

  @Published private var searchQuery: String?
  @Published private(set) var state: State = .idle

  private var cancellable: AnyCancellable?

  func start() {
    cancellable = $searchQuery
      .receive(on: DispatchQueue.main)
      .debounce(for: .milliseconds(500), scheduler: RunLoop.main, options: nil)
      .sink(receiveValue: { self.performSearch(with: $0) })
  }

  private func performSearch(with query: String?) {
    guard let query = query, !query.isEmpty else {
      state = .idle
      return
    }
    let searchRequest = MKLocalSearch.Request()
    searchRequest.naturalLanguageQuery = query
    searchRequest.resultTypes = .address
    let search = MKLocalSearch(request: searchRequest)
    search.start { response, error in
      if error != nil {
        self.state = .error
      } else if let response = response {
        let searchResults = response.mapItems.compactMap { $0.placemark }
        self.state = searchResults.isEmpty ? .noResults : .success(searchResults)
      }
    }
  }
}

extension SearchViewModel: UISearchResultsUpdating {

  func updateSearchResults(for searchController: UISearchController) {
    searchQuery = searchController.searchBar.text
  }
}
