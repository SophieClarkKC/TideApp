//
//  SearchViewModel.swift
//  TideApp
//
//  Created by John Sanderson on 17/05/2021.
//

import Foundation
import UIKit

final class SearchViewModel: NSObject, ObservableObject {

  @Published var searchResults: [String] = []

  func search(using query: String?) {
    //TODO: Perform search and update view state
    print("Searching using query: \(query)")
  }
}

extension SearchViewModel: UISearchResultsUpdating {

  func updateSearchResults(for searchController: UISearchController) {
    search(using: searchController.searchBar.text)
  }
}
