//
//  LocationSearcher.swift
//  TideApp
//
//  Created by Marco Guerrieri on 19/05/2021.
//

import Foundation
import MapKit

protocol LocationSearcherType {
  func search(query: String, completion: @escaping (([MKMapItem]?, Error?)->Void))
}

struct LocationSearcher: LocationSearcherType {

  func search(query: String, completion: @escaping (([MKMapItem]?, Error?)->Void)) {
    let searchRequest = MKLocalSearch.Request()
    searchRequest.naturalLanguageQuery = query
    let search = MKLocalSearch(request: searchRequest)
    search.start { response, error in
      guard error == nil else {
        return completion(nil, error)
      }
      guard let response = response else {
        return completion([], nil)
      }
      completion(response.mapItems, nil)
    }
  }
  
}
