//
//  SearchControllerProvider.swift
//  TideApp
//
//  Created by John Sanderson on 17/05/2021.
//

import UIKit

final class SearchControllerProvider  {

  private let resultsUpdater: UISearchResultsUpdating
  lazy var searchController: UISearchController = {
    let searchController = UISearchController(searchResultsController: nil)
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchResultsUpdater = resultsUpdater
    return searchController
  }()

  init(resultsUpdater: UISearchResultsUpdating) {
    self.resultsUpdater = resultsUpdater
  }
}
